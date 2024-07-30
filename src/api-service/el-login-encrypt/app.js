const express = require('express');
var rsa = require( "./RSA" );
// 创建app实例
const app = express();

// 请求
app.use(express.raw());
app.use(express.json());
app.use(express.text());

// 创建一个 /api/rsaEncrypted 路由
app.post('/api/rsaEncrypted', (req, res) => {
    const data = req.body;
    const result = {};
    
    result.account = rsa.GetRASEncryptedString(data.key,data.account);
    result.password = rsa.GetRASEncryptedString(data.key,data.password);
    // res.writeHead(200,{'Content-Type':'application/json'});
    res.json(result);
});
// 启动服务
const port = 3000;
app.listen(port, () => {
    console.log(`Server started on port ${port}`);
});
