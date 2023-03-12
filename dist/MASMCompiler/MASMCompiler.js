var opCodes = { 'NOP': '0', 'BNK': '1', 'OUT': '2', 'CLC': '3', 'SEC': '4', 'LSL': '5', 'ROL': '6', 'LSR': '7',
    'ROR': '8', 'ASR': '9', 'INP': '10', 'NEG': '11', 'INC': '12', 'DEC': '13', 'LDI': '14', 'ADI': '15',
    'SBI': '16', 'CPI': '17', 'ACI': '18', 'SCI': '19', 'JPA': '20', 'LDA': '21', 'STA': '22', 'ADA': '23',
    'SBA': '24', 'CPA': '25', 'ACA': '26', 'SCA': '27', 'JPR': '28', 'LDR': '29', 'STR': '30', 'ADR': '31',
    'SBR': '32', 'CPR': '33', 'ACR': '34', 'SCR': '35', 'CLB': '36', 'NEB': '37', 'INB': '38', 'DEB': '39',
    'ADB': '40', 'SBB': '41', 'ACB': '42', 'SCB': '43', 'CLW': '44', 'NEW': '45', 'INW': '46', 'DEW': '47',
    'ADW': '48', 'SBW': '49', 'ACW': '50', 'SCW': '51', 'LDS': '52', 'STS': '53', 'PHS': '54', 'PLS': '55',
    'JPS': '56', 'RTS': '57', 'BNE': '58', 'BEQ': '59', 'BCC': '60', 'BCS': '61', 'BPL': '62', 'BMI': '63' };
var lineinfo = [], lineadr = [], labels = {};
var LINEINFO_NONE = 0x00000, LINEINFO_ORG = 0x10000, LINEINFO_BEGIN = 0x20000, LINEINFO_END = 0x40000;
export function masmcompile(source) {
    var lines = source.replace("\r\n", "\n").split("\n").map(function (x) { return x.trim(); });
    for (var i = 0; i < lines.length; i++) {
        while (lines[i].indexOf("'") != -1) {
            var k_1 = lines[i].indexOf("'");
            var l = lines[i].indexOf("'", k_1 + 1);
            if (k_1 != -1 && l != -1) {
                var replaced = '';
                for (var _i = 0, _a = lines[i].slice(k_1 + 1, l); _i < _a.length; _i++) {
                    var char = _a[_i];
                    replaced += char.charCodeAt(0).toString() + " ";
                }
                lines[i] = lines[i].slice(0, k_1) + replaced + lines[i].slice(l + 1);
            }
            else {
                break;
            }
        }
        if (lines[i].indexOf(";") != -1) {
            lines[i] = lines[i].slice(0, lines[i].indexOf(";"));
        }
        lines[i] = lines[i].replace(',', ' ');
        lineinfo.push(LINEINFO_NONE);
        if (lines[i].indexOf("#begin") != -1) {
            lineinfo[i] |= LINEINFO_BEGIN;
            lines[i] = lines[i].replace('#begin', '');
        }
        else if (lines[i].indexOf("#end") != -1) {
            lineinfo[i] |= LINEINFO_END;
            lines[i] = lines[i].replace('#end', '');
        }
        var k = lines[i].indexOf('#org');
        if (k != -1) {
            var s = lines[i].slice(k).split(" ");
            var rest = "";
            lineinfo[i] |= LINEINFO_ORG + parseInt(s[1]);
            for (var _b = 0, _c = s.slice(2); _b < _c.length; _b++) {
                var el = _c[_b];
                rest += " " + el;
            }
            lines[i] = (lines[i].slice(0, k) + rest).trim();
        }
        if (lines[i].indexOf(":") != -1) {
            labels[lines[i].slice(0, lines[i].indexOf(":"))] = i;
            lines[i] = lines[i].slice(lines[i].indexOf(':') + 1);
        }
        lines[i] = lines[i].split(" ");
        for (var j = lines[i].length - 1; j >= 0; j--) {
            try {
                lines[i] = stringSet(lines[i], j, opCodes[lines[i][j]]);
            }
            catch (e) {
                if (lines[i][j].indexOf("0x") == 0 && lines[i][j].length > 4) {
                    var val = parseInt(lines[i][j], 16);
                    lines[i] = stringSet(lines[i], j, (val & 0xff).toString());
                    lines[i] = lines[i].slice(0, j + 1) + ((val >> 8) & 0xff).toString() + lines[i].slice(j + 1);
                }
            }
        }
    }
    var adr = 0;
    for (var i = 0; i < lines.length; i++) {
        for (var j = lines[i].length - 1; j >= 0; j--) {
            var e = lines[i][j];
            if (typeof e == "undefined") {
                continue;
            }
            if (e[0] == '<' || e[0] == '>')
                continue;
            if (e.indexOf('+') != -1) {
                e = e.slice(0, e.indexOf("+"));
            }
            if (e.indexOf('-') != -1) {
                e = e.slice(0, e.indexOf("-"));
            }
            try {
                lines[i] = lines[i].slice(0, j + 1) + '0x@@' + lines[i].slice(j + 1);
            }
            catch (e) {
            }
        }
        if (lineinfo[i] & LINEINFO_ORG) {
            adr = lineinfo[i] & 0xffff;
        }
        lineadr.push(adr);
        adr += lines[i].length;
    }
    for (var l in labels) {
        labels[l] = lineadr[labels[l]];
    }
    for (var i = 0; i < lines.length; i++) {
        for (var j = 0; j < lines[i].length; j++) {
            var e = lines[i][j];
            var pre = '';
            var off = 0;
            if (typeof e == "undefined") {
                continue;
            }
            if (e[0] == "<" || e[0] == ">") {
                pre = e[0];
                e = e.slice(1);
            }
            if (e.indexOf("+") != -1) {
                off += parseInt(e.slice(e.indexOf("+") + 1));
                e = e.slice(0, e.indexOf("+"));
            }
            if (e.indexOf("-") != -1) {
                off += parseInt(e.slice(e.indexOf("-") + 1));
                e = e.slice(0, e.indexOf("-"));
            }
            try {
                adr = labels[e] + off;
                if (pre == "<") {
                    lines[i] = stringSet(lines[i], j, (adr & 0xff).toString());
                }
                else if (pre == ">") {
                    lines[i] = stringSet(lines[i], j, ((adr >> 8) & 0xff).toString());
                }
                else {
                    lines[i] = stringSet(lines[i], j, (adr & 0xff).toString());
                    lines[i] = stringSet(lines[i], j + 1, ((adr >> 8) & 0xff).toString());
                }
            }
            catch (e) {
            }
            try {
                parseInt(lines[i][j]);
            }
            catch (e) {
                console.log('ERROR in line ' + (i + 1) + ': Undefined expression \'' + lines[i][j] + '\'');
                process.exit(1);
            }
        }
    }
    var insert = '', showout = true;
    for (var i = 0; i < lines.length; i++) {
        if (lineinfo[i] & LINEINFO_BEGIN) {
            showout = true;
        }
        if (lineinfo[i] & LINEINFO_END) {
            showout = false;
        }
        if (showout) {
            if (lineinfo[i] & LINEINFO_ORG) {
                if (insert) {
                    console.log(":" + insert);
                    insert = "";
                }
                console.log("".concat((lineinfo[i] & 0xffff).toString(16).padStart(4, '0')));
            }
            for (var _d = 0, _e = lines[i]; _d < _e.length; _d++) {
                var e = _e[_d];
                insert += (parseInt(e, 16) & 0xff).toString(16).padStart(2, '0') + " ";
                if (insert.length >= 16 * 3 - 1) {
                    console.log(":" + insert);
                    insert = "";
                }
            }
        }
    }
    if (insert) {
        console.log(":" + insert);
    }
}
function stringSet(str, index, value) {
    str[index] = value;
    return str;
}
