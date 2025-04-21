# Use official Node.js image
FROM node:16-slim

# Set environment variables
ENV NODE_ENV=production
ENV PORT=3000  

# Set work directory
WORKDIR /app

# Install dependencies
COPY package*.json ./
RUN npm install

# Copy project files
COPY . .

# Expose default port (3000 for React app)
EXPOSE 3000

# Start the application
CMD ["npm", "start"]
