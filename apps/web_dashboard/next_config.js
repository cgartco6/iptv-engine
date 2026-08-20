/** @type {import('next').NextScript} */
const nextConfig = {
  reactStrictMode: true,
  transpilePackages: ["parser_engine"],
  async headers() {
    return [
      {
        source: "/api/:path*",
        headers: [
          { key: "Access-Control-Allow-Origin", value: "*" },
          { key: "Access-Control-Allow-Methods", value: "GET,POST,OPTIONS" },
          { key: "Access-Control-Allow-Headers", value: "Content-Type, Authorization" }
        ]
      }
    ];
  }
};

export default nextConfig;
