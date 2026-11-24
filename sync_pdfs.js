const fs = require("fs");
const path = require("path");
const pdfsRoot = path.join(__dirname, "www", "pdfs");
const outFile = path.join(__dirname, "www", "exams_data.js");
const subjMap = {
  civics: "សីលធម៌-ពលរដ្ឋវិទ្យា",
  earth: "ភូមិវិទ្យា/ផែនដី",
  english: "ភាសាអង់គ្លេស",
  french: "ភាសាបារាំង",
  geography: "ភូមិវិទ្យា",
  history: "ប្រវត្តិវិទ្យា",
  khmer: "អក្សរសាស្ត្រខ្មែរ",
  math: "គណិតវិទ្យា"
};
const items = [];
for (const yr of fs.readdirSync(pdfsRoot).sort()) {
  const yrDir = path.join(pdfsRoot, yr);
  if (!fs.statSync(yrDir).isDirectory()) continue;
  for (const file of fs.readdirSync(yrDir).filter(f => f.toLowerCase().endsWith(".pdf")).sort()) {
    const base = path.basename(file, path.extname(file)).toLowerCase();
    const subj = subjMap[base] || base;
    items.push({
      id: `${base}-${yr}`,
      subj,
      tag: `ផ្លូវការ ${yr}`,
      type: "past",
      title: `វិញ្ញាសា និងអត្រាកំណែ ${subj} (${yr})`,
      question: "វិញ្ញាសាប្រឡងសញ្ញាបត្រមធ្យមសិក្សាទុតិយភូមិ",
      answer: "",
      pdf: `pdfs/${yr}/${file}`
    });
  }
}
fs.writeFileSync(outFile, `window.EXAM_PAGES_DIR = "pages/";\nwindow.EXAM_ARCHIVE = ${JSON.stringify(items, null, 2)};\n`, "utf8");
console.log("Done! Total PDFs linked:", items.length);
