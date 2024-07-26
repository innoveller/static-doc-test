const express = require('express');
const path = require('path');

const app = express();
const port = 3000;

app.get('/highlightStyle', (req, res) => {
    const filePath = path.resolve('dist/public', '1c-light.css')
    res.sendFile(filePath)
})

app.get('/highlightJs', (req, res) => {
    const filePath = path.resolve('dist/public', 'highlight.min.js')
    res.sendFile(filePath)
})

app.get('/gherkinHighligher', (req, res) => {
    const filePath = path.resolve('dist/public', 'gherkin-highlighter.js')
    res.sendFile(filePath)
})

app.get('/addPayment', (req, res) => {
    const filePath = path.resolve('dist/admin/partial_payment', 'add_payment.txt');
    res.sendFile(filePath);
})

app.get('/settingPayableOption', (req, res) => {
    const filePath = path.resolve('dist/admin/partial_payment', 'setting_payable_options.txt');
    res.sendFile(filePath);
})

app.get('/dirReader', (req, res) => {
    const filePath = path.resolve('dist/public', '')
})

app.get('/', (req, res) => {
    const filePath = path.resolve('dist/public', 'home.html');
    res.sendFile(filePath);
})

app.listen(port, () => {
  console.log(`Server is running on http://localhost:${port}`);
});