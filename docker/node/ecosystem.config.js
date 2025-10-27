module.exports = {
  apps: [
    {
      name: "node-api",
      script: "index.js",
      instances: 1,
      autorestart: true,
      watch: false,
      max_memory_restart: "1G",
      env: {
        NODE_ENV: "development",
        PORT: 3000,
        MONGODB_URI: "mongodb://root:rootpassword@mongodb:27017",
        REDIS_URL: "redis://redis:6379",
      },
      error_file: "/var/log/pm2/error.log",
      out_file: "/var/log/pm2/out.log",
      log_file: "/var/log/pm2/combined.log",
      time: true,
    },
  ],
};
