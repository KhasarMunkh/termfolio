FROM node:20-alpine

WORKDIR /app

# Install dependencies
COPY package*.json ./
RUN npm ci --only=production

# Copy built files
COPY dist ./dist
COPY public ./public

# Create projects directory
RUN mkdir -p /app/projects

EXPOSE 3000

CMD ["node", "dist/server.js"]
