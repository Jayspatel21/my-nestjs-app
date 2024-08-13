# Use Node.js 18 as the base image
FROM node:18

# Set working directory inside the container
WORKDIR /app

# Copy dependency definitions
COPY package.json yarn.lock ./

# Install dependencies
RUN yarn install --frozen-lockfile

# Install additional tools
RUN apt-get update && apt-get install -y awscli jq && apt-get clean

# AWS credentials and region (passed during build time or runtime)
ARG AWS_ACCESS_KEY_ID
ARG AWS_SECRET_ACCESS_KEY
ARG AWS_REGION

# Fetch secrets from AWS Secrets Manager and store them in .env
RUN aws secretsmanager get-secret-value --secret-id Envfile-stage --region us-east-1 | \
    jq -r '.SecretString | fromjson | to_entries | .[] | "\(.key)=\(.value)"' > .env && \
    cat .env

# Copy the rest of the application code
COPY . .

# Uncomment if you are using Prisma
# RUN yarn prisma:generate
# RUN yarn prisma-all

# Build the application
RUN yarn run build

# Expose the API port
EXPOSE 1401

# Start the application in production mode
CMD ["sh", "-c", "yarn run start:prod"]
