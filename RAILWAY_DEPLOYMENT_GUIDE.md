# Railway Deployment Guide - Fuel Tracking System

This guide provides step-by-step instructions to deploy the Laravel fuel tracking system on Railway with both the application and database.

## Prerequisites

- GitHub repository connected to Railway
- Railway account at [railway.app](https://railway.app)
- This project with `railway.toml` properly configured

## Environment Variables Required

The following environment variables must be set in Railway dashboard:

### Application Configuration
```
APP_NAME=sales_tracking
APP_ENV=production
APP_DEBUG=false
APP_KEY=base64:BmmZ993rARtI3Qb2Fs8X0Bh3gLE+rUI1dfe434LMqxs=
APP_URL=https://your-railway-app.up.railway.app
APP_LOCALE=en
APP_FALLBACK_LOCALE=en
LOG_CHANNEL=stack
LOG_LEVEL=info
```

### Database Configuration (Auto-linked by Railway)
```
DB_CONNECTION=mysql
DB_HOST=${{MySQL.PRIVATE_URL}}
DB_PORT=3306
DB_DATABASE=${{MySQL.DB_NAME}}
DB_USERNAME=${{MySQL.DB_USER}}
DB_PASSWORD=${{MySQL.DB_PASSWORD}}
```

### Session & Cache
```
SESSION_DRIVER=database
SESSION_LIFETIME=120
CACHE_STORE=database
QUEUE_CONNECTION=database
FILESYSTEM_DISK=local
```

### Mail (Optional)
```
MAIL_MAILER=log
```

## Deployment Steps

### 1. Create Railway Project
- Go to [railway.app](https://railway.app) and sign in
- Create a new project
- Select "GitHub" and authorize Railway
- Choose this repository

### 2. Add MySQL Database Service
- In your Railway project, click **Add Service** → **Database** → **MySQL**
- Railway will automatically generate `DB_HOST`, `DB_DATABASE`, `DB_USERNAME`, `DB_PASSWORD`
- These are auto-linked to your app via `${{MySQL.*}}` references in `railway.toml`

### 3. Configure Environment Variables
- In the app service settings, go to **Variables**
- Add the environment variables from the list above
- **Important**: Replace `https://your-railway-app.up.railway.app` with your actual Railway domain
  - You can find it under your app service name in the dashboard
  - Format is typically `project-name.up.railway.app`

### 4. Set APP_KEY
- The APP_KEY is already set in the environment variables
- If you want to generate a new one locally:
  ```bash
  php artisan key:generate --show
  ```
- Copy the output (starts with `base64:`) and paste it as `APP_KEY` in Railway

### 5. Deploy
- After connecting repository and setting environment variables, Railway automatically deploys
- Monitor deployment progress in **Deployments** tab
- Check logs for:
  - PHP build process
  - npm build (Vite assets)
  - Database migrations running
  - Server starting on `0.0.0.0:{PORT}`

### 6. Verify Deployment
- Open your app URL: `https://your-app-name.up.railway.app`
- Should redirect to login page
- Database migrations should have run automatically
- Check logs if there are any errors

## Build Process (Automated)

The `railway.toml` `buildCommand` runs:
1. `composer install --optimize-autoloader` - PHP dependencies
2. `npm install && npm run build` - Vite frontend asset compilation
3. `php artisan key:generate` - Encryption key (if not set)
4. `php artisan optimize` - Cache optimization

## Start Process (Automated)

The `startCommand` runs:
1. `php artisan migrate --force` - Database migrations (creates tables if needed)
2. `php artisan serve` - Starts Laravel dev server

## Database Migrations

Migrations run automatically on every deployment via the `startCommand`. If you need to rollback:
- Use Railway's "Revert" deployment feature to deploy a previous version
- Or manually connect to MySQL and run `php artisan migrate:rollback`

## Troubleshooting

### Build Fails
- Check build logs in Railway dashboard
- Ensure `package.json` and `composer.json` are in root directory
- Verify `railway.toml` syntax (TOML format)

### Database Connection Error
- Verify MySQL service is added and running
- Check environment variables match `${{MySQL.*}}` format
- Ensure `DB_HOST` is the PRIVATE_URL for internal Railway communication

### Migrations Not Running
- Check app logs: `php artisan migrate --force` output
- Verify database user has privileges to create tables
- Manually run migrations via Railway CLI if needed

### Static Assets Not Loading
- Verify `npm run build` completed in build logs
- Check that CSS/JS files are in `public/build/` directory
- Clear browser cache and hard refresh

### 404 on Non-Root Routes
- Ensure `.htaccess` is deployed (Laravel default)
- Verify `APP_URL` matches your Railway domain
- Check routes are in `routes/web.php`

## Monitoring & Maintenance

### View Logs
- In Railway dashboard, open your app service
- Click **Logs** to see real-time output
- Filter by service type (Web, Database, Build)

### Environment Variable Changes
- Update variables in Railway dashboard
- Railway auto-triggers a redeploy
- Migrations run again if database was modified

### Database Access
- Connect to MySQL database using Railway's connection string
- Available in MySQL service settings under **Connect**
- Use MySQL Workbench, TablePlus, or command line

## Performance Optimization (Optional)

1. **Enable Caching**
   - Update `CACHE_STORE=file` instead of `database` for better performance
   - Note: File cache persists across deploys on Railway

2. **Static Asset CDN**
   - After assets build, consider using a CDN for `public/build/`
   - Update `APP_URL` to CDN URL if implemented

3. **Database Optimization**
   - Migrations include indexes for performance
   - Monitor slow queries in logs

## Scaling (Future)

- Railway supports horizontal scaling of app services
- Database can be upgraded to higher tier if needed
- Configure in Railway project settings

## References

- [Railway Documentation](https://docs.railway.app/)
- [Laravel Deployment](https://laravel.com/docs/deployment)
- [Railway Environment Variables](https://docs.railway.app/develop/variables)
