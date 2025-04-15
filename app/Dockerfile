# ---------- 1. Install dependencies and build ----------
    FROM node:18-alpine AS builder

    WORKDIR /app
    
    # Ensure consistent builds by copying only necessary files first
    COPY package.json package-lock.json ./
    
    RUN npm ci
    
    # Copy rest of the app source code
    COPY . .
    
    # Build the app for production using standalone mode
    RUN npm run build
    
    # ---------- 2. Final runtime image ----------
    FROM node:18-alpine AS runner
    
    WORKDIR /app
    
    ENV NODE_ENV=production
    ENV PORT=3000
    ENV HOSTNAME=0.0.0.0
    
    # Optional: Disable Next.js telemetry
    # ENV NEXT_TELEMETRY_DISABLED=1
    
    # Create non-root user
    RUN addgroup -g 1001 -S nodejs && adduser -S nextjs -u 1001
    
    # Copy only the essential output for the standalone app
    COPY --from=builder /app/public ./public
    COPY --from=builder --chown=nextjs:nodejs /app/.next/standalone ./
    COPY --from=builder --chown=nextjs:nodejs /app/.next/static ./.next/static
    
    # For prerender cache (optional, if used)
    RUN mkdir .next && chown nextjs:nodejs .next
    
    USER nextjs
    
    EXPOSE 3000
    
    CMD ["node", "server.js"]
    