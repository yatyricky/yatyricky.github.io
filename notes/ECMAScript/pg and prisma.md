## Install PG

```
apt update
apt install postgresql postgresql-contrib
```

```
pg_lsclusters
```

Ver Cluster Port Status Owner    Data directory              Log file
14  main    5432 online postgres /var/lib/postgresql/14/main /var/log/postgresql/postgresql-14-main.log

Edit `/etc/postgresql/{ver}/main/postgresql.conf`

Find the line with `listen_addresses` and change it to: `listen_addresses = '*'`

Edit the client authentication configuration: `/etc/postgresql/{ver}/main/pg_hba.conf`

Add this `host    all             all             0.0.0.0/0               md5`

Restart `systemctl restart postgresql`

Setup user

```
# First, switch to postgres user
sudo -i -u postgres

# Start psql
psql

# In psql prompt, change the password
ALTER USER postgres PASSWORD 'your_new_password';

CREATE DATABASE database_name;

# Generate Prisma client
npx prisma generate

# Create tables based on your schema
npx prisma migrate dev --name commit_message

# Exit psql
\q
```

prisma

```

## 1. Setup Prisma (Already Done)

Your schema.prisma file is already set up with:
- PostgreSQL as the database provider
- Environment variable for database URL
- User model with basic fields

## 2. Setting Up Database Connection

### Update Your .env File

Ensure your `.env` file has the correct database URL:

## 3. Initialize Prisma Client

Create a client file that you can import throughout your application:


## 4. Modify Your User Class to Use Prisma

Update your User.js file to use Prisma instead of the direct MySQL queries:


## 5. Common CRUD Operations with Prisma

Here are examples of common database operations using Prisma:

```javascript
// Create a new user
async function createUser(userData) {
    return await prisma.user.create({
        data: userData
    });
}

// Find a user by ID
async function findUserById(id) {
    return await prisma.user.findUnique({
        where: { id }
    });
}

// Find a user by WeChat account
async function findUserByWeChatAccount(accQywx) {
    return await prisma.user.findUnique({
        where: { accQywx }
    });
}

// Update a user
async function updateUser(id, userData) {
    return await prisma.user.update({
        where: { id },
        data: userData
    });
}

// Delete a user
async function deleteUser(id) {
    return await prisma.user.delete({
        where: { id }
    });
}

// List all users
async function listAllUsers() {
    return await prisma.user.findMany();
}
```

## 6. Running Migrations

When you change your Prisma schema, you need to run migrations:

```bash
# Generate migration files from schema changes
npx prisma migrate dev --name add_user_fields

# Apply migrations to production (after testing)
npx prisma migrate deploy
```

## 7. Extending Your Schema

As your application grows, you can extend your schema with additional models:

```prisma
model User {
    id        String    @id @default(uuid())
    name      String
    accQywx   String?   @unique
    createdAt DateTime  @default(now())
    updatedAt DateTime  @updatedAt
    posts     Post[]    // Relation to posts
    
    @@map("users")
}

model Post {
    id        String   @id @default(uuid())
    title     String
    content   String?
    published Boolean  @default(false)
    authorId  String
    author    User     @relation(fields: [authorId], references: [id])
    createdAt DateTime @default(now())
    updatedAt DateTime @updatedAt
    
    @@map("posts")
}
```

## 8. Using Transactions

For operations that need to be atomic:

```javascript
async function transferOwnership(postId, newUserId) {
    return await prisma.$transaction(async (tx) => {
        // Find the post
        const post = await tx.post.findUnique({ where: { id: postId } });
        if (!post) throw new Error('Post not found');
        
        // Update the post's author
        await tx.post.update({
            where: { id: postId },
            data: { authorId: newUserId }
        });
        
        // Log the transfer
        await tx.activityLog.create({
            data: {
                action: 'TRANSFER_OWNERSHIP',
                details: `Post ${postId} transferred to user ${newUserId}`
            }
        });
    });
}
```

## 9. Best Practices for Prisma

1. **Use a central client**: Import the Prisma client from one file to maintain a single connection pool.

2. **Handle errors properly**:
   ```javascript
   try {
       const result = await prisma.user.findMany();
       // Process result
   } catch (error) {
       console.error('Database error:', error);
       // Handle different error types
   }
   ```

3. **Use select for performance**:
   ```javascript
   const users = await prisma.user.findMany({
       select: {
           id: true,
           name: true
           // Only select fields you need
       }
   });
   ```

4. **Use middleware** for logging or transformations:
   ```javascript
   prisma.$use(async (params, next) => {
       const before = Date.now();
       const result = await next(params);
       const after = Date.now();
       console.log(`Query ${params.model}.${params.action} took ${after - before}ms`);
       return result;
   });
   ```

## 10. Integrating with Your Fastify Server

In your main server file:

```javascript
import Fastify from 'fastify';
import User from './User/User.js';
import prisma from './prisma.js';

const fastify = Fastify({
    logger: true
});

// Register routes
User.Register(fastify);

// Add a hook to handle Prisma connection
fastify.addHook('onClose', async (instance) => {
    await prisma.$disconnect();
});

const start = async () => {
    try {
        await fastify.listen({ port: 3000, host: '0.0.0.0' });
    } catch (err) {
        fastify.log.error(err);
        process.exit(1);
    }
};

start();
```

This should give you a solid foundation for using Prisma in your xlgbis-server application. Let me know if you need more specific examples or have questions about particular Prisma features!

Similar code found with 1 license type
```

npx prisma migrate dev --name initial_schema
npx prisma validate
npx prisma db pull