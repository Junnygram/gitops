# --- Builder Stage ---
    FROM node:21-alpine AS builder

    # Disable Next.js telemetry
    ENV NEXT_TELEMETRY_DISABLED 1
    
    WORKDIR /app
    
    # Install dependencies
    COPY package.json package-lock.json ./
    RUN npm install
    
    # Copy source code
    COPY . .
    
    # Build the Next.js app
    RUN npm run build
    
    # --- Runner Stage ---
    FROM node:21-alpine AS runner
    
    ENV NODE_ENV=production
    ENV NEXT_TELEMETRY_DISABLED=1
    
    # Create app directory and user
    WORKDIR /app
    RUN addgroup --system --gid 1001 nodejs
    RUN adduser --system --uid 1001 nextjs
    
    # Copy built app and dependencies
    COPY --from=builder --chown=nextjs:nodejs /app/.next ./.next
    COPY --from=builder --chown=nextjs:nodejs /app/public ./public
    COPY --from=builder --chown=nextjs:nodejs /app/node_modules ./node_modules
    COPY --from=builder --chown=nextjs:nodejs /app/package.json ./package.json
    
    # Set permissions and expose
    USER nextjs
    EXPOSE 3000
    
    # Default port
    ENV PORT=3000
    
    # Start the app
    CMD ["npm", "start"]
    