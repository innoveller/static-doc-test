import { opendirSync } from 'fs'

const dir = opendirSync('.')
let dirent
while ((dirent = dir.readSync()) !== null) {
  console.log(dirent.name)
}
dir.closeSync()