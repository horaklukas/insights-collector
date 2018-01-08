# Insights collector

> Application for collecting reports about your websites performance using [Google PageSpeed Insights](https://developers.google.com/speed/pagespeed/insights/)

[Running application instance](http://insights-collector.horaklukas.cz)

## How to start develop it

1. Start development api with `yarn start` or `npm start`
2. Run app in development mode `yarn dev` or `npm run dev`

## Runing by yourself

If you want from any reason to run app on your own server, it' really easy to make it works:

1. Copy all files from `dist` directory into root of your server
2. Copy database file `db.json` into web root
3. Depending on your backend technology:
  1. PHP - copy `src/api/api.php` and `src/api/.htaccess` into web root
  2. Node.js 

## License

MIT