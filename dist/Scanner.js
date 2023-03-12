var Scanner = (function () {
    function Scanner(text) {
        this.text = text;
        this.lastMatch = null;
        this.matches = null;
        this.cursor = 0;
        this.originalText = this.text;
    }
    Scanner.prototype.getLine = function () {
        var str = this.originalText.substring(0, this.cursor);
        var lines = str.split("\n");
        return lines.length;
    };
    Scanner.prototype.getLines = function () {
        return this.originalText.split("\n");
    };
    Scanner.prototype.getColumn = function () {
        var str = this.originalText.substring(0, this.cursor);
        var lines = str.split("\n");
        return lines[lines.length - 1].length + 1;
    };
    Scanner.prototype.blanks = function () {
        var textLength = this.text.length;
        this.text = this.text.replace(/^\s+/, '');
        this.cursor += textLength - this.text.length;
    };
    ;
    Scanner.prototype.match = function (pattern) {
        if (pattern instanceof RegExp) {
            return this.matchRegularExpression(pattern);
        }
        return this.matchString(pattern);
    };
    ;
    Scanner.prototype.matchRegularExpression = function (re) {
        var result = re.exec(this.text);
        if (result !== null) {
            this.lastMatch = result[0];
            this.matches = result;
            this.text = this.text.substring(result[0].length);
            this.cursor += result[0].length || 0;
            return true;
        }
        return false;
    };
    ;
    Scanner.prototype.matchString = function (str) {
        if (this.text.substring(0, str.length) === str) {
            this.lastMatch = str;
            this.matches = [str];
            this.text = this.text.substring(str.length);
            this.cursor += str.length || 0;
            return true;
        }
        return false;
    };
    ;
    return Scanner;
}());
;
export { Scanner };
