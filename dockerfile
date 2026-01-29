# =========================
# Builder Stage
# =========================
FROM node:24-alpine AS builder

WORKDIR /app

# Install dependencies
COPY package*.json ./
RUN npm install

# Copy source code
COPY . .

# Build the project
RUN npm run build


# =========================
# Production Stage
# =========================
FROM node:24-alpine

WORKDIR /app

# Copy only required files
COPY package*.json ./
RUN npm ci --only=production

# Copy node_modules & build output from builder
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/dist ./dist

# Environment
ENV NODE_ENV=production

# Expose port
EXPOSE 3000
ENTRYPOINT ["npm", "run"]
CMD ["start:prod"]


