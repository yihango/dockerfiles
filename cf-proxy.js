addEventListener("fetch", (event) => {
  event.respondWith(handleRequest(event.request));
});

async function handleRequest(request) {
  try {
    const url = new URL(request.url);

    // 如果访问根目录，返回HTML
    if (url.pathname === "/") {
      return new Response(getRootHtml(), {
        headers: {
          "Content-Type": "text/html; charset=utf-8",
        },
      });
    }

    // 目标根地址,自行替换
    const targetBaseUrl = "http://xxx.com";

    // 从请求路径中提取目标 URL
    let actualUrlStr = decodeURIComponent(url.pathname.replace("/", ""));

    // 判断用户输入的 URL 是否带有协议
    actualUrlStr = ensureProtocol(targetBaseUrl + actualUrlStr, url.protocol);

    // 保留查询参数
    actualUrlStr += url.search;

    // 创建新 Headers 对象，排除以 'cf-' 开头的请求头
    const newHeaders = filterHeaders(
      request.headers,
      (name) => !name.startsWith("cf-")
    );

    // 创建一个新的请求以访问目标 URL
    const modifiedRequest = new Request(actualUrlStr, {
      headers: newHeaders,
      method: request.method,
      body: request.body,
      redirect: "manual",
    });

    // 发起对目标 URL 的请求
    const response = await fetch(modifiedRequest);
    let body = response.body;

    // 处理重定向
    if ([301, 302, 303, 307, 308].includes(response.status)) {
      body = response.body;
      // 创建新的 Response 对象以修改 Location 头部
      return handleRedirect(response, body);
    } else if (response.headers.get("Content-Type")?.includes("text/html")) {
      body = await handleHtmlContent(
        response,
        url.protocol,
        url.host,
        actualUrlStr
      );
    }

    // 创建修改后的响应对象
    const modifiedResponse = new Response(body, {
      status: response.status,
      statusText: response.statusText,
      headers: response.headers,
    });

    // 添加禁用缓存的头部
    setNoCacheHeaders(modifiedResponse.headers);

    // 添加 CORS 头部，允许跨域访问
    setCorsHeaders(modifiedResponse.headers);

    return modifiedResponse;
  } catch (error) {
    // 如果请求目标地址时出现错误，返回带有错误消息的响应和状态码 500（服务器错误）
    return jsonResponse(
      {
        error: error.message,
      },
      500
    );
  }
}

// 确保 URL 带有协议
function ensureProtocol(url, defaultProtocol) {
  return url.startsWith("http://") || url.startsWith("https://")
    ? url
    : defaultProtocol + "//" + url;
}

// 处理重定向
function handleRedirect(response, body) {
  const location = new URL(response.headers.get("location"));
  const modifiedLocation = `/${encodeURIComponent(location.toString())}`;
  return new Response(body, {
    status: response.status,
    statusText: response.statusText,
    headers: {
      ...response.headers,
      Location: modifiedLocation,
    },
  });
}

// 处理 HTML 内容中的相对路径
async function handleHtmlContent(response, protocol, host, actualUrlStr) {
  const originalText = await response.text();
  const regex = new RegExp("((href|src|action)=[\"'])/(?!/)", "g");
  let modifiedText = replaceRelativePaths(
    originalText,
    protocol,
    host,
    new URL(actualUrlStr).origin
  );

  return modifiedText;
}

// 替换 HTML 内容中的相对路径
function replaceRelativePaths(text, protocol, host, origin) {
  const regex = new RegExp("((href|src|action)=[\"'])/(?!/)", "g");
  return text.replace(regex, `$1${protocol}//${host}/${origin}/`);
}

// 返回 JSON 格式的响应
function jsonResponse(data, status) {
  return new Response(JSON.stringify(data), {
    status: status,
    headers: {
      "Content-Type": "application/json; charset=utf-8",
    },
  });
}

// 过滤请求头
function filterHeaders(headers, filterFunc) {
  return new Headers([...headers].filter(([name]) => filterFunc(name)));
}

// 设置禁用缓存的头部
function setNoCacheHeaders(headers) {
  headers.set("Cache-Control", "no-store");
}

// 设置 CORS 头部
function setCorsHeaders(headers) {
  headers.set("Access-Control-Allow-Origin", "*");
  headers.set("Access-Control-Allow-Methods", "GET, POST, PUT, DELETE");
  headers.set("Access-Control-Allow-Headers", "*");
}

// 返回根目录的 HTML
function getRootHtml() {
  return `
  <!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>页面未找到 - 404错误</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            color: #333;
            line-height: 1.6;
        }
        
        .error-container {
            background: rgba(255, 255, 255, 0.95);
            padding: 3rem;
            border-radius: 20px;
            box-shadow: 0 15px 35px rgba(0, 0, 0, 0.1);
            text-align: center;
            max-width: 500px;
            width: 90%;
            animation: fadeIn 0.8s ease-out;
        }
        
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(30px); }
            to { opacity: 1; transform: translateY(0); }
        }
        
        .error-code {
            font-size: 8rem;
            font-weight: bold;
            color: #667eea;
            line-height: 1;
            margin-bottom: 1rem;
            text-shadow: 3px 3px 0 rgba(0, 0, 0, 0.1);
        }
        
        .error-title {
            font-size: 2rem;
            margin-bottom: 1rem;
            color: #2d3748;
        }
        
        .error-message {
            color: #4a5568;
            margin-bottom: 2rem;
            font-size: 1.1rem;
        }
        
        .action-buttons {
            display: flex;
            gap: 1rem;
            justify-content: center;
            flex-wrap: wrap;
            margin-top: 2rem;
        }
        
        .btn {
            padding: 0.75rem 1.5rem;
            border: none;
            border-radius: 50px;
            font-size: 1rem;
            cursor: pointer;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-block;
            font-weight: 600;
        }
        
        .btn-primary {
            background: #667eea;
            color: white;
        }
        
        .btn-primary:hover {
            background: #5a6fd8;
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(102, 126, 234, 0.4);
        }
        
        .btn-secondary {
            background: #e2e8f0;
            color: #4a5568;
        }
        
        .btn-secondary:hover {
            background: #cbd5e0;
            transform: translateY(-2px);
        }
        
        .countdown {
            margin-top: 1.5rem;
            padding: 1rem;
            background: #f7fafc;
            border-radius: 10px;
            font-size: 0.9rem;
            color: #718096;
        }
        
        .countdown-number {
            font-weight: bold;
            color: #667eea;
        }
        
        @media (max-width: 480px) {
            .error-container {
                padding: 2rem 1.5rem;
            }
            
            .error-code {
                font-size: 6rem;
            }
            
            .error-title {
                font-size: 1.5rem;
            }
            
            .action-buttons {
                flex-direction: column;
                align-items: center;
            }
            
            .btn {
                width: 100%;
                max-width: 250px;
            }
        }
    </style>
</head>
<body>
    <div class="error-container">
        <div class="error-code">404</div>
        <h1 class="error-title">页面迷路了</h1>
        <p class="error-message">
            抱歉，您要访问的页面不存在。可能已被移动、删除，或者您输入了错误的网址。
        </p>
        
        <div class="action-buttons">
            <a href="https://store.steampowered.com/" class="btn btn-primary">返回首页</a>
            <a href="javascript:history.back()" class="btn btn-secondary">返回上一页</a>
        </div>
        
        <div class="countdown">
            <span id="countdown-text"><span class="countdown-number">10</span> 秒后自动跳转到首页</span>
        </div>
    </div>

    <script>
        // 倒计时功能
        let seconds = 10;
        const countdownElement = document.getElementById('countdown-text');
        const countdownNumber = countdownElement.querySelector('.countdown-number');
        
        const countdown = setInterval(() => {
            seconds--;
            countdownNumber.textContent = seconds;
            
            if (seconds <= 0) {
                clearInterval(countdown);
                window.location.href = 'https://store.steampowered.com/';
            }
        }, 1000);
        
        // 如果用户与页面交互，停止自动跳转
        document.addEventListener('click', () => {
            clearInterval(countdown);
            countdownElement.innerHTML = '自动跳转已取消';
        });
    </script>
</body>
</html>`;
}
