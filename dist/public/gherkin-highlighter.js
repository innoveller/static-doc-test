document.body.addEventListener('htmx:afterSwap', function(evt) {
    console.log("Content Loaded!");

    const element = document.getElementById('response-div');
    delete element.dataset.highlighted;

    hljs.highlightAll();
});