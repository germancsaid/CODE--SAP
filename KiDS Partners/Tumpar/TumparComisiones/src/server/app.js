// Importa los módulos necesarios de Express y otras librerías
import express from 'express';
import path from 'path';
import flash from 'express-flash';
import session from 'express-session';
import methodOverride from 'method-override';
import passport from 'passport';

// Importa el archivo que configura la estrategia de autenticación de Passport
require('./services/passport-auth');

// Crea la aplicación de Express
const app = express();

// Configura la carpeta pública y la vista
app.use(express.static(path.join(__dirname, '..', 'public')));
app.set('views', path.join(__dirname, '..', 'public'));
app.set('view engine', 'ejs');

// Configura los middlewares
app.use(express.urlencoded({ extended: false }))
app.use(flash())

// Configura la sesión de Express
const sessionMiddleware = session({
secret: process.env.SESSION_SECRET || 'secretito',
resave: false,
saveUninitialized: false
});
app.use(sessionMiddleware);
app.use(passport.initialize())
app.use(passport.session())
app.use(methodOverride('_method'))

// Configura las rutas
import router from './routes';
app.use(router);

// Exporta el middleware de sesión y la aplicación de Express
export { sessionMiddleware };
export default app;