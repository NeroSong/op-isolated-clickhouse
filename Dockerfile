# 使用官方 ClickHouse 基础镜像
FROM clickhouse/clickhouse-server:24.3.2-alpine

# 将本地配置文件和脚本复制到镜像内的正确位置
# config.d 用于自定义配置，users.d 用于用户配置
# docker-entrypoint-initdb.d 用于初始化脚本，在容器启动时执行
COPY ./configs/clickhouse-config.xml /etc/clickhouse-server/config.d/op-config.xml
COPY ./configs/clickhouse-user-config.xml /etc/clickhouse-server/users.d/op-user-config.xml
COPY ./configs/init-db.sh /docker-entrypoint-initdb.d/init-db.sh

# 确保初始化脚本有执行权限
RUN chmod +x /docker-entrypoint-initdb.d/init-db.sh

# 修改容器的 ulimits 设置
RUN echo "* soft nofile 262144" >> /etc/security/limits.conf && \
    echo "* hard nofile 262144" >> /etc/security/limits.conf

# 暴露 ClickHouse 的端口
EXPOSE 9000
EXPOSE 8123
