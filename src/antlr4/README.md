# 说明
antlr4 镜像

## 用例
```shell
# 指定命令行参数
alias antlr4='docker run -it -u $(id -u ${USER}):$(id -g ${USER}) -v $(pwd):/work staneee/antlr4:4.12.0 $@'

# 下载语法配置
wget https://raw.githubusercontent.com/antlr/grammars-v4/master/sql/tsql/TSqlLexer.g4
wget https://raw.githubusercontent.com/antlr/grammars-v4/master/sql/tsql/TSqlParser.g4


# 运行
antlr4 -Dlanguage=CSharp TSqlLexer.g4
antlr4 -Dlanguage=CSharp TSqlParser.g4
```

---

## 官方镜像文件
基于官方代码仓库打包的镜像

### 镜像列表：
- staneee/antlr4:4.12.0
