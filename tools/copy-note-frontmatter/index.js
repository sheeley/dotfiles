import { promises } from "fs";
import { join } from "path";
import { load } from "js-yaml"

const actuallyWrite = false
const verbose = false
const changeFilename = false
const notesDir = process.env["NOTES_DIR"]

let filesWritten = 0
const reg = /---\n(.*?)\n---\n/s

function log() {
    verbose && console.log.apply(null, arguments)
}

async function* walk(dir) {
    for await (const d of await promises.opendir(dir)) {
        const entry = join(dir, d.name);
        if (d.isDirectory()) yield* walk(entry);
        else if (d.isFile()) yield entry;
    }
}

async function main() {
    for await (const p of walk(notesDir)) {
        log(p)
        if (!p.endsWith(".md") || p.endsWith(".new.md")) { log(`skipping ${p}: md`); continue }

        const buf = await promises.readFile(p)
        const contents = buf.toString()
        if (!contents.startsWith("---\n")) { log(`skipping ${p}: ---`); continue }

        const res = contents.match(reg)
        if (!res) { log(`skipping ${p}: regex`); continue }
        // log(p, res.length, res)
        if (res.length != 2) { log(`skipping ${p}: match count`); continue }

        const ysrc = res[1]
        // log(p, ysrc)
        const parsed = load(ysrc)
        if (!parsed) {
            log(`skipping ${p}: yaml parse ${ysrc}`);
            continue
        }

        const key = `attendees`
        const pull = parsed[key]
        if (!pull) { log(`skipping ${p}: no ${key}`); continue }
        const newContents = `${contents}
        
---
## Attendees
${pull.join("\n")}
`

        const stats = await promises.stat(p)
        if (!stats) { log(`skipping ${p}: stats`); continue }

        const newFile = changeFilename ? p.replace(".md", ".new.md") : p

        if (actuallyWrite) {
            await promises.writeFile(newFile, newContents)
            await promises.utimes(newFile, stats.atime, stats.mtime)
        } else {
            console.log(`${newFile}:\n${newContents}`)
        }
        filesWritten++
    }
}

await main()
console.log(`${filesWritten} files ${actuallyWrite ? "" : "would be "}written`)