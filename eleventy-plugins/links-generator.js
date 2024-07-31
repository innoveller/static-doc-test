const fs = require("fs");
const path = require('path');

const parents = new Map();

module.exports = function(eleventyConfig) {
    var srcpath = "features";

    var links = [];

    var dirs = getDirectoriesRecursive(srcpath);
    for(var index = 0; index < dirs.length; index++) {
        
        var dir = dirs[index].replaceAll('features\\', '').replaceAll('\\', '/');

        if(dir !== "features") {
            var link;
            if(dir.includes('/')) {
                var lastIndexOfSlash = dir.lastIndexOf('/');

                var dirWithoutLastSlash = dir.substring(0, lastIndexOfSlash);
    
                var parentName = dirWithoutLastSlash.substring(dirWithoutLastSlash.lastIndexOf('/') + 1);
    
                var dirName = dir.substring(lastIndexOfSlash + 1);
                
                var parentId = parents.get(parentName);
    
                link = { "id": index, "parent_id": parentId, "name": capitalize(dirName), "url": "" };
                parents.set(dirName, index);
    
            }
            else {
                link = { "id": index, "parent_id": null, "name": capitalize(dir), "url": "" };
                parents.set(dir, index);
            }
    
            links.push(link);
        }
        
        var files = getFiles(dirs[index]);
        for(var fIndex = 0 ; fIndex < files.length ; fIndex++) {
            var url = files[fIndex].replaceAll('features\\', '').replaceAll('\\', '/').replaceAll('.feature', '.txt');

            if(url.includes('/')) {
                var lastIndexOfSlash = url.lastIndexOf('/');

                var urlWithoutLastSlash = url.substring(0, lastIndexOfSlash);

                var parentName = urlWithoutLastSlash.substring(urlWithoutLastSlash.lastIndexOf('/') + 1);

                var fileName = url.substring(lastIndexOfSlash + 1);
                
                var parentId = parents.get(parentName);

                link = { "id": (dirs.length + fIndex), "parent_id": parentId, "name": capitalize(fileName), "url": url };
            }
            else {
                link = {"id": (dirs.length + fIndex), "parent_id": null, "name": capitalize(url), "url": url};
            }
            
            links.push(link);
        }
    }

    var result = [];
    for(var index = 0; index < links.length; index++) {
        var current = links[index];
        var link;

        if(current.url === "" && current.parent_id === null) {
            const filteredLinks = links.filter((item) => item.id !== current.id);
            link = { "id": current.id, "parent_id": current.parent_id, "name": capitalize(current.name), children: getChildren(current.id, filteredLinks) }
            result.push(link);
        }
        else if(current.parent_id === null) {
            
            link = { "id": current.id, "parent_id": current.parent_id, "name": capitalize(current.name), "url": current.url }
            result.push(link);
        }
    }

    fs.writeFile(
    "features/_data/links.json",
    JSON.stringify(result),
    err => {
        // Checking for errors 
        if (err) throw err;

        // Success 
        console.log("Links has been generated.");
    }); 
}

function capitalize(name) {
    return name.replaceAll('.txt', '').replaceAll('_', ' ').toLowerCase()
    .split(' ')
    .map(word => word.charAt(0).toUpperCase() + word.slice(1))
    .join(' ');
}

function getChildren(id, links) {
    var children = [];
    for(var index = 0; index < links.length; index++) {
        var current = links[index];

        if(current.parent_id === id) {
            var link;
            if(current.url === "") {
                const filteredLinks = links.filter((item) => item.id !== current.id);
                link = { "id": current.id, "parent_id": current.parent_id, "name": current.name, children: getChildren(current.id, filteredLinks) }
            }
            else {
                link = { "id": current.id, "parent_id": current.parent_id, "name": current.name, "url": current.url }
            }
            
            children.push(link);
        }
    }

    return children;
}

function flatten(lists) {
    return lists.reduce((a, b) => a.concat(b), []);
  }
  
  function getDirectories(srcpath) {
    return fs.readdirSync(srcpath)
      .map(file => path.join(srcpath, file))
      .filter(path => fs.statSync(path).isDirectory() && !path.includes("_data") && !path.includes("_includes") );
  }
  
  function getDirectoriesRecursive(srcpath) {
    return [srcpath, ...flatten(getDirectories(srcpath).map(getDirectoriesRecursive))];
  }

  function getFiles(srcpath) {
    return fs.readdirSync(srcpath)
        .map(file => path.join(srcpath, file))
        .filter(path => !fs.statSync(path).isDirectory() && !path.includes("index.njk") );
  }