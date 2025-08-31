# 第一阶段：依赖下载
FROM golang:1.21 AS deps

WORKDIR /app

# 添加一些模拟的go.mod和go.sum文件
RUN echo 'module github.com/openimsdk/test-project' > go.mod && \
    echo 'go 1.21' >> go.mod && \
    echo 'require (' >> go.mod && \
    echo '  github.com/gin-gonic/gin v1.9.1' >> go.mod && \
    echo '  github.com/go-redis/redis/v8 v8.11.5' >> go.mod && \
    echo '  github.com/spf13/viper v1.16.0' >> go.mod && \
    echo '  go.mongodb.org/mongo-driver v1.12.1' >> go.mod && \
    echo '  google.golang.org/grpc v1.58.2' >> go.mod && \
    echo '  google.golang.org/protobuf v1.31.0' >> go.mod && \
    echo ')' >> go.mod

# 安装一些额外的工具和依赖，这会花费一些时间
RUN apt-get update && \
    apt-get install -y git curl build-essential protobuf-compiler && \
    go install google.golang.org/protobuf/cmd/protoc-gen-go@v1.28 && \
    go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@v1.2 && \
    go install github.com/golang/mock/mockgen@v1.6.0 && \
    go install github.com/swaggo/swag/cmd/swag@latest

# 下载依赖，这会消耗一定时间
RUN go mod download

# 添加一个故意延时的操作，确保构建不会太快
RUN sleep 15

# 第二阶段：代码编译
FROM deps AS builder

WORKDIR /app

# 创建一些基本的源文件结构
RUN mkdir -p cmd/server api/proto internal/pkg config

# 创建一个简单的main.go文件
RUN echo 'package main\n\nimport (\n  "fmt"\n  "net/http"\n  "time"\n)\n\nfunc main() {\n  fmt.Println("Starting server...")\n  http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {\n    time.Sleep(100 * time.Millisecond)\n    fmt.Fprintf(w, "Hello from OpenIM Server!")\n  })\n  http.ListenAndServe(":8080", nil)\n}' > cmd/server/main.go

# 模拟生成一些protobuf文件
RUN echo 'syntax = "proto3";\npackage api;\noption go_package = "github.com/openimsdk/test-project/api/gen";\n\nservice UserService {\n  rpc GetUser(GetUserRequest) returns (GetUserResponse);\n}\n\nmessage GetUserRequest {\n  string user_id = 1;\n}\n\nmessage GetUserResponse {\n  string user_id = 1;\n  string username = 2;\n}' > api/proto/user.proto

# 模拟编译protobuf文件
RUN mkdir -p api/gen && \
    echo 'package gen\n\ntype UserServiceServer interface {\n  GetUser(req *GetUserRequest) (*GetUserResponse, error)\n}\n\ntype GetUserRequest struct {\n  UserId string\n}\n\ntype GetUserResponse struct {\n  UserId   string\n  Username string\n}' > api/gen/user.pb.go

# 编译项目，添加一些额外的编译参数以增加编译时间
RUN go build -ldflags="-s -w" -o bin/server ./cmd/server/

# 模拟运行测试
RUN echo 'package main\n\nimport "testing"\n\nfunc TestMain(t *testing.T) {\n  // Just a placeholder test\n}' > cmd/server/main_test.go && \
    cd cmd/server && go test -v

# 故意添加延时以模拟长时间构建
RUN sleep 20

# 第三阶段：最终镜像
FROM alpine:latest

WORKDIR /app

# 安装一些运行时依赖
RUN apk add --no-cache ca-certificates tzdata libc6-compat && \
    cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
    echo "Asia/Shanghai" > /etc/timezone

# 模拟一些配置文件
RUN mkdir -p /app/config && \
    echo '{"server":{"port":8080},"database":{"host":"localhost","port":5432}}' > /app/config/config.json

# 从构建阶段复制编译好的应用
COPY --from=builder /app/bin/server /app/server

# 添加健康检查命令
COPY --from=builder /app/bin/server /usr/local/bin/server
RUN echo '#!/bin/sh\necho "Health check passed!"\nexit 0' > /usr/local/bin/mage && \
    chmod +x /usr/local/bin/mage

# 模拟更多文件复制
RUN mkdir -p /app/static && \
    echo '<html><body><h1>OpenIM Server</h1></body></html>' > /app/static/index.html

# 再次故意延时
RUN sleep 10

# 设置环境变量
ENV APP_ENV=production \
    LOG_LEVEL=info \
    SERVER_PORT=8080

# 暴露端口
EXPOSE 8080

# 启动应用
CMD ["/app/server"]