const xlsx = require("xlsx")
const fs = require("fs");
const path = require("path")

const wb = xlsx.readFile("C:\\Users\\yatyr\\workspace\\svn\\11.barrett\\Config\\Globals.xlsx")
const sheet = wb.Sheets["@Types"]

console.log(sheet.B13.v)