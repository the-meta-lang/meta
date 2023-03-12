const opCodes = { 'NOP':'0',  'BNK':'1',  'OUT':'2',  'CLC':'3',  'SEC':'4',  'LSL':'5',  'ROL':'6',  'LSR':'7',
            'ROR':'8',  'ASR':'9',  'INP':'10', 'NEG':'11', 'INC':'12', 'DEC':'13', 'LDI':'14', 'ADI':'15',
            'SBI':'16', 'CPI':'17', 'ACI':'18', 'SCI':'19', 'JPA':'20', 'LDA':'21', 'STA':'22', 'ADA':'23',
            'SBA':'24', 'CPA':'25', 'ACA':'26', 'SCA':'27', 'JPR':'28', 'LDR':'29', 'STR':'30', 'ADR':'31',
            'SBR':'32', 'CPR':'33', 'ACR':'34', 'SCR':'35', 'CLB':'36', 'NEB':'37', 'INB':'38', 'DEB':'39',
            'ADB':'40', 'SBB':'41', 'ACB':'42', 'SCB':'43', 'CLW':'44', 'NEW':'45', 'INW':'46', 'DEW':'47',
            'ADW':'48', 'SBW':'49', 'ACW':'50', 'SCW':'51', 'LDS':'52', 'STS':'53', 'PHS':'54', 'PLS':'55',
            'JPS':'56', 'RTS':'57', 'BNE':'58', 'BEQ':'59', 'BCC':'60', 'BCS':'61', 'BPL':'62', 'BMI':'63'  }

let lineinfo = [], lineadr = [], labels = {}
const LINEINFO_NONE = 0x00000, LINEINFO_ORG = 0x10000, LINEINFO_BEGIN = 0x20000, LINEINFO_END	= 0x40000

export function masmcompile(source: string) {
	const lines = source.replace("\r\n", "\n").split("\n").map(x => x.trim());

	for (let i = 0; i < lines.length; i++) {
		// PASS 1: do PER LINE replacements
		// replace '...' occurances with corresponding ASCII code(s)
		while(lines[i].indexOf("'") != -1) {
			let k = lines[i].indexOf("'")
			let l = lines[i].indexOf("'", k+1)
			if (k != -1 && l != -1){
					let replaced = ''
					for (const char of lines[i].slice(k+1, l)) {
						replaced += char.charCodeAt(0).toString() + " ";
					}
					lines[i] = lines[i].slice(0, k) + replaced + lines[i].slice(l+1);
				} else {
					break
				}
		}

		if (lines[i].indexOf(";") != -1) {
			// delete comments
			lines[i] = lines[i].slice(0, lines[i].indexOf(";"))
		}
		// replace commas with spaces
		lines[i] = lines[i].replace(',', ' ')

		// generate a separate lineinfo
    lineinfo.push(LINEINFO_NONE)
		if (lines[i].indexOf("#begin") != -1) {
			lineinfo[i] |= LINEINFO_BEGIN
			lines[i] = lines[i].replace('#begin', '')
		} else if (lines[i].indexOf("#end") != -1) {
			lineinfo[i] |= LINEINFO_END
			lines[i] = lines[i].replace('#end', '')
		}

    let k = lines[i].indexOf('#org')
    if (k != -1) {
			let s = lines[i].slice(k).split(" "); 
			// split from #org onwards
			let rest = ""
			// use element after #org as origin address
			lineinfo[i] |= LINEINFO_ORG + parseInt(s[1])
			for (const el of s.slice(2)) {
				rest += " " + el
			}
			// join everything before and after the #org ... statement
			lines[i] = (lines[i].slice(0, k) + rest).trim()
		}      
    
		if (lines[i].indexOf(":") != -1) {
			// put label with it's line number into dictionary
			labels[lines[i].slice(0, lines[i].indexOf(":"))] = i
			// cut out the label
			lines[i] = lines[i].slice(lines[i].indexOf(':')+1)
		}
		// now split line into list of bytes (omitting whitepaces)
    lines[i] = lines[i].split(" ")

		for(let j = lines[i].length - 1; j >= 0; j--){
			// iterate from back to front while inserting stuff
			// try replacing mnemonic with opcode
			try {
				lines[i] = stringSet(lines[i], j, opCodes[lines[i][j]])
			} catch(e) {
				if (lines[i][j].indexOf("0x") == 0 && lines[i][j].length > 4) {
					// replace '0xWORD' with 'LSB MSB'
					let val = parseInt(lines[i][j], 16)
					lines[i] = stringSet(lines[i], j, (val & 0xff).toString());
					lines[i] = lines[i].slice(0, j+1) + ((val >> 8) & 0xff).toString() + lines[i].slice(j+1);
				}
			}
		}
	}

	// PASS 2: default start address
	let adr = 0
	for (let i = 0; i < lines.length; i++) {
		for(let j = lines[i].length - 1; j >= 0; j--){
			let e = lines[i][j]
			if (typeof e == "undefined") {
				continue;
			}
			// only one byte is required for this label         
			if (e[0] == '<' || e[0] == '>') continue;
			if (e.indexOf('+') != -1) {
				// omit +/- expressions after a label
				e = e.slice(0, e.indexOf("+"));
			}
			if (e.indexOf('-') != -1) {
				e = e.slice(0, e.indexOf("-"));
			}
			try {
				// is this element a label? => add a placeholder for the MSB
				lines[i] = lines[i].slice(0, j+1) + '0x@@' + lines[i].slice(j+1);
			} catch(e) {

			}
		}
		if (lineinfo[i] & LINEINFO_ORG) {
			// react to #org by resetting the address
			adr = lineinfo[i] & 0xffff
		}
		// save line start address
		lineadr.push(adr);
		// advance address by number of (byte) elements
		adr += lines[i].length;
	}
	for (const l in labels) {
		// update label dictionary from 'line number' to 'address'
		labels[l] = lineadr[labels[l]]
	}

	for (let i = 0; i < lines.length; i++) {
		// PASS 3: replace 'reference + placeholder' with 'MSB LSB'
		for (let j = 0; j < lines[i].length; j++) {
			let e = lines[i][j]
			let pre = ''
			let off = 0
			if (typeof e == "undefined") {
				continue;
			}
			if (e[0] == "<" || e[0] == ">") {
				pre = e[0];
				e = e.slice(1)
			}
			if (e.indexOf("+") != -1) {
				off += parseInt(e.slice(e.indexOf("+")+1));
				e = e.slice(0, e.indexOf("+"));
			}
			if (e.indexOf("-") != -1) {
				off += parseInt(e.slice(e.indexOf("-")+1));
				e = e.slice(0, e.indexOf("-"));
			}
			try {
				adr = labels[e] + off
				if (pre == "<") {
					lines[i] = stringSet(lines[i], j, (adr & 0xff).toString());
				} else if (pre == ">") {
					lines[i] = stringSet(lines[i], j, ((adr>>8) & 0xff).toString())
				} else {
					lines[i] = stringSet(lines[i], j, (adr & 0xff).toString())
					lines[i] = stringSet(lines[i], j + 1, ((adr>>8) & 0xff).toString())
				}
			} catch(e) {
				
			}
			try {
				parseInt(lines[i][j]);
			} catch(e) {
				console.log('ERROR in line ' + (i+1) + ': Undefined expression \'' + lines[i][j] + '\'')
				process.exit(1)
			}
		}
	}

	// print out 16 data bytes per row in Minimal's 'cut & paste' format
	let insert = '', showout = true
	for (let i = 0; i < lines.length; i++) {
		if (lineinfo[i] & LINEINFO_BEGIN) {
			showout = true;
		}
		if (lineinfo[i] & LINEINFO_END) {
			showout = false;
		}
		if (showout) {
			if (lineinfo[i] & LINEINFO_ORG) {
				if (insert) {
					console.log(":" + insert)
					insert = "";
				}
				console.log(`${(lineinfo[i] & 0xffff).toString(16).padStart(4, '0')}`);
			}
			for (const e of lines[i]) {
				insert += (parseInt(e, 16) & 0xff).toString(16).padStart(2, '0') + " "
				if (insert.length >= 16 * 3 - 1) {
					console.log(":" + insert);
					insert = ""
				}
			}
		}
	}
	if (insert) {
		console.log(":" + insert);
	}

	//return lines
}

function stringSet(str: string[], index: number, value: any) {
	str[index] = value;
	return str;
}