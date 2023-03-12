import { parse } from "./parse.js";
var Builder = (function () {
    function Builder() {
        this.text = "       ";
    }
    Builder.prototype.copy = function (string) {
        this.text += string;
    };
    Builder.prototype.label = function () {
        this.text = this.text.slice(0, -7);
    };
    Builder.prototype.newLine = function () {
        this.text += "\n       ";
    };
    Builder.prototype.getProgram = function () {
        return parse(this.text);
    };
    return Builder;
}());
export { Builder };
