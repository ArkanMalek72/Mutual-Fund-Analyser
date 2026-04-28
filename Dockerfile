# Dockerfile
FROM node:20-alpine AS builder

WORKDIR /app

# Install root deps (concurrently)
COPY package.json ./
RUN npm install

# Build client
COPY client/package.json ./client/
RUN cd client && npm install

COPY client/ ./client/
RUN cd client && npm run build

# ─── Production stage ────────────────────────────────────────────────────────
FROM node:20-alpine

WORKDIR /app

# Server deps only
COPY server/package.json ./server/
RUN cd server && npm install --omit=dev

COPY server/ ./server/

# Copy built client
COPY --from=builder /app/client/dist ./client/dist

# DB directory
RUN mkdir -p /data

ENV NODE_ENV=production
ENV PORT=3001
ENV DB_PATH=/data/fundscope.db

EXPOSE 3001

CMD ["node", "server/index.js"]
