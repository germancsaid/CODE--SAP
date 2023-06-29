// Importamos las librerías y módulos necesarios
import express from 'express';
import passport from 'passport';
import { checkAuthenticated, checkNotAuthenticated } from './utils/middlewares';
import parametro from "./models/parametro";




// Creamos el router de Express
const router = express.Router();

// Definimos la ruta para la página de registro
router.get('/register', checkNotAuthenticated, (req, res) => {
  // Renderizamos la vista correspondiente
  res.render('register.ejs')
});

// Definimos la ruta para procesar el formulario de registro
router.post('/register', checkNotAuthenticated, passport.authenticate('local-signup', {
  successRedirect: '/login',
  failureRedirect: '/register',
  failureFlash: true 
}), (req, res) => {
  // Si el registro ha sido exitoso, enviamos un correo electrónico de confirmación al usuario
  sendConfirmationEmail(req.user);
});

router.get('/confirm', (req, res) => {
  const token = req.query.token;
  const email = verifyToken(token, 'confirm');
  if (email) {
    // Actualizar el estado de confirmación de correo electrónico del usuario en tu base de datos
    // Redirigir al usuario a la página de inicio de sesión
    res.redirect('/login');
  } else {
    // Si el token no es válido, mostrar un mensaje de error al usuario
    res.send('Token no válido');
  }
});

// Definimos la ruta para la página de inicio de sesión
router.get('/login', checkNotAuthenticated, (req, res) => {
  // Renderizamos la vista correspondiente
  res.render('login.ejs')
});

// Definimos la ruta para procesar el formulario de inicio de sesión
router.post('/login', checkNotAuthenticated, passport.authenticate('local-signin', {
  successRedirect: '/',
  failureRedirect: '/login',
  failureFlash: true
}));

// Definimos la ruta para la página de inicio
router.get('/', checkAuthenticated, (req, res) => {
  // Comprobamos si el usuario está autenticado
  const isAuthenticated = !!req.user;
  if (isAuthenticated) {
    // Si está autenticado, establecemos los datos del usuario en la respuesta y renderizamos la vista correspondiente
    res.locals.userData = { 
      _id: req.user._id, 
      Email: req.user.Email,
      PlayerName: req.user.PlayerName,
      TeamName: req.user.TeamName,
    };
    res.render('index.ejs', { _id: req.user._id, Email: req.user.Email, PlayerName: req.user.PlayerName, TeamName: req.user.TeamName });
    /*
    console.log(`Session ${req.session.id}`);
    console.log(`User ID ${req.user._id}`);
    */
  } else {
    // Si no está autenticado, simplemente mostramos un mensaje en la consola
    console.log("unknown user");
  }
});

// Definimos la ruta para la página de datos
router.get('/datos', checkAuthenticated, (req, res) => {
  // Comprobamos si el usuario está autenticado
  const isAuthenticated = !!req.user;
  if (isAuthenticated) {
    // Si está autenticado, establecemos los datos del usuario en la respuesta y renderizamos la vista correspondiente
    res.locals.userData = { 
      _id: req.user._id, 
      Email: req.user.Email,
      PlayerName: req.user.PlayerName,
      TeamName: req.user.TeamName,
    };
    res.render('datos.ejs', { _id: req.user._id, Email: req.user.Email, PlayerName: req.user.PlayerName, TeamName: req.user.TeamName });
    /*
    console.log(`Session ${req.session.id}`);
    console.log(`User ID ${req.user._id}`);
    */
  } else {
    // Si no está autenticado, simplemente mostramos un mensaje en la consola
    console.log("unknown user");
  }
});


// Definimos la ruta para la página de cobranzas
router.get('/cobranzas', checkAuthenticated, (req, res) => {
  // Comprobamos si el usuario está autenticado
  const isAuthenticated = !!req.user;
  if (isAuthenticated) {
    // Si está autenticado, establecemos los datos del usuario en la respuesta y renderizamos la vista correspondiente
    res.locals.userData = { 
      _id: req.user._id, 
      Email: req.user.Email,
      PlayerName: req.user.PlayerName,
      TeamName: req.user.TeamName,
    };
    res.render('cobranzas.ejs', { _id: req.user._id, Email: req.user.Email, PlayerName: req.user.PlayerName, TeamName: req.user.TeamName });
  } else {
    // Si no está autenticado, simplemente mostramos un mensaje en la consola
    console.log("unknown user");
  }
});

// Definimos la ruta para la página de politicas
router.get('/politicas', checkAuthenticated, (req, res) => {
  // Comprobamos si el usuario está autenticado
  const isAuthenticated = !!req.user;
  if (isAuthenticated) {
    // Si está autenticado, establecemos los datos del usuario en la respuesta y renderizamos la vista correspondiente
    res.locals.userData = { 
      _id: req.user._id, 
      Email: req.user.Email,
      PlayerName: req.user.PlayerName,
      TeamName: req.user.TeamName,
    };
    res.render('politicas.ejs', { _id: req.user._id, Email: req.user.Email, PlayerName: req.user.PlayerName, TeamName: req.user.TeamName });
  } else {
    // Si no está autenticado, simplemente mostramos un mensaje en la consola
    console.log("unknown user");
  }
});

// Definimos la ruta para la página de stream
router.get('/stream', checkAuthenticated, (req, res) => {
  // Comprobamos si el usuario está autenticado
  const isAuthenticated = !!req.user;
  if (isAuthenticated) {
    // Si está autenticado, establecemos los datos del usuario en la respuesta y renderizamos la vista correspondiente
    res.locals.userData = { 
      _id: req.user._id, 
      Email: req.user.Email,
      PlayerName: req.user.PlayerName,
      TeamName: req.user.TeamName,
    };
    res.render('stream.ejs', { _id: req.user._id, Email: req.user.Email, PlayerName: req.user.PlayerName, TeamName: req.user.TeamName });
  } else {
    // Si no está autenticado, simplemente mostramos un mensaje en la consola
    console.log("unknown user");
  }
});

// Definimos la ruta para cerrar sesión
router.delete('/logout', function(req, res, next) {
  req.logOut(function(err) {
    if (err) { return next(err); }
    res.redirect('/login')
  })
});

router.post('/api/new/parametro', async (req, res) => {
  const { nombreParametro, nuevaLinea } = req.body;
  try {
    const parametroExistente = await parametro.findOne({ Parametro: nombreParametro });
  
    if (parametroExistente) {
      parametroExistente.Rango.push(nuevaLinea);
      await parametroExistente.save();
      res.status(200).json({ message: "Línea agregada correctamente al parámetro existente." });
    } else {
      await Parametro.create({ Parametro: nombreParametro, Rango: [nuevaLinea] });
      res.status(200).json({ message: "Nuevo parámetro creado correctamente." });
    }
  } catch (error) {
    res.status(500).json({ error: "Error al actualizar el parámetro." });
  }
});


router.post('/b1s/v1/TablaTOT', (req, res) => {
  const TablaTOT = [{"CODE":55,"VENDEDOR":"ALARCON SERGIO EDUARDO","Columna1":null,"CC":"LPZ","CONTADO":"43879.03","CREDITO":"12588.91","ANTICIPO":"7662.95","OTROS":"0","NOTAS_CREDITO":"0","DEVOLUCIONES_OTROS":"0","TOTAL_USD":"64130.89"},{"CODE":60,"VENDEDOR":"ARE MORALES YVANISSE","Columna1":null,"CC":"CENT","CONTADO":"23434.23","CREDITO":"161.51","ANTICIPO":"224.53","OTROS":"0","NOTAS_CREDITO":"0","DEVOLUCIONES_OTROS":"35","TOTAL_USD":"23785.27"},{"CODE":64,"VENDEDOR":"BARRIENTOS MUCARZEL VALENTINA JOSE","Columna1":null,"CC":"CENT","CONTADO":"82451.96","CREDITO":"1930.36","ANTICIPO":"18793.66","OTROS":"0","NOTAS_CREDITO":"0","DEVOLUCIONES_OTROS":"0","TOTAL_USD":"103175.98"},{"CODE":25,"VENDEDOR":"CABRERA ROCA LIZZY","Columna1":null,"CC":"CENT","CONTADO":"19570.18","CREDITO":"42136.12","ANTICIPO":"50865.07","OTROS":"189","NOTAS_CREDITO":"0","DEVOLUCIONES_OTROS":"170","TOTAL_USD":"112590.37"},{"CODE":63,"VENDEDOR":"CARDOZO VEGA ANA BELEN","Columna1":null,"CC":"CBBA","CONTADO":"4770.76","CREDITO":"825.6","ANTICIPO":"1831.04","OTROS":"0","NOTAS_CREDITO":"0","DEVOLUCIONES_OTROS":"40","TOTAL_USD":"7387.40"},{"CODE":18,"VENDEDOR":"CASTRO CUELLAR JOANA","Columna1":null,"CC":"CENT","CONTADO":"37946.90","CREDITO":"23143.59","ANTICIPO":"41604.02","OTROS":"772.8","NOTAS_CREDITO":"0","DEVOLUCIONES_OTROS":"86.5","TOTAL_USD":"103380.81"},{"CODE":68,"VENDEDOR":"CAYO YA\u00d1EZ CARLA ANELIZ","Columna1":null,"CC":"CBBA","CONTADO":"9808.67","CREDITO":"0","ANTICIPO":"0","OTROS":"0","NOTAS_CREDITO":"0","DEVOLUCIONES_OTROS":"0","TOTAL_USD":"9808.67"},{"CODE":48,"VENDEDOR":"CHALE MORALES MARIANA","Columna1":null,"CC":"CUS","CONTADO":"3376.75","CREDITO":"112370.29","ANTICIPO":"0","OTROS":"0","NOTAS_CREDITO":"0","DEVOLUCIONES_OTROS":"0","TOTAL_USD":"115747.04"},{"CODE":2,"VENDEDOR":"COLLAZOS VARGAS ROSELVINA","Columna1":null,"CC":"BUSH","CONTADO":"19121.37","CREDITO":"0","ANTICIPO":"19068.79","OTROS":"0","NOTAS_CREDITO":"0","DEVOLUCIONES_OTROS":"0","TOTAL_USD":"38190.16"},{"CODE":40,"VENDEDOR":"CUELLAR ANGULO JULIO CESAR","Columna1":null,"CC":"CENT","CONTADO":"103718.79","CREDITO":"25242.00","ANTICIPO":"1030.00","OTROS":"0","NOTAS_CREDITO":"0","DEVOLUCIONES_OTROS":"140","TOTAL_USD":"129850.79"},{"CODE":29,"VENDEDOR":"FLORES GUARDIA DANIELA","Columna1":null,"CC":"CENT","CONTADO":"3852.21","CREDITO":"1460.57","ANTICIPO":"777.07","OTROS":"0","NOTAS_CREDITO":"0","DEVOLUCIONES_OTROS":"0","TOTAL_USD":"6089.85"},{"CODE":7,"VENDEDOR":"FLORES SAUCEDO PABLO FERNANDO","Columna1":null,"CC":"PROY","CONTADO":"41628.32","CREDITO":"64146.85","ANTICIPO":"101715.83","OTROS":"0","NOTAS_CREDITO":"0","DEVOLUCIONES_OTROS":"342.37","TOTAL_USD":"207148.63"},{"CODE":38,"VENDEDOR":"HIZA MENACHO SARA YAMILE","Columna1":null,"CC":"CENT","CONTADO":"63212.77","CREDITO":"60688.09","ANTICIPO":"119540.53","OTROS":"2479.60","NOTAS_CREDITO":"0","DEVOLUCIONES_OTROS":"0","TOTAL_USD":"245920.99"},{"CODE":5,"VENDEDOR":"HOYOS ARAUZ PABLO LEONIDAS","Columna1":null,"CC":"DIST","CONTADO":"13218.59","CREDITO":"33723.01","ANTICIPO":"0","OTROS":"0","NOTAS_CREDITO":"0","DEVOLUCIONES_OTROS":"0","TOTAL_USD":"46941.60"},{"CODE":66,"VENDEDOR":"ILLANES VERA CINTHYA MARIANA","Columna1":null,"CC":"LPZ","CONTADO":"22118.27","CREDITO":"0","ANTICIPO":"4606.77","OTROS":"0","NOTAS_CREDITO":"0","DEVOLUCIONES_OTROS":"0","TOTAL_USD":"26725.04"},{"CODE":27,"VENDEDOR":"LAZO DUABYAKOSKY ANA MARIA","Columna1":null,"CC":"CENT","CONTADO":"6702.97","CREDITO":"0","ANTICIPO":"0","OTROS":"0","NOTAS_CREDITO":"0","DEVOLUCIONES_OTROS":"0","TOTAL_USD":"6702.97"},{"CODE":65,"VENDEDOR":"LLANOS MOLINA MARIA FERNANDA","Columna1":null,"CC":"KM9","CONTADO":"16498.49","CREDITO":"26.99","ANTICIPO":"8316.64","OTROS":"0","NOTAS_CREDITO":"0","DEVOLUCIONES_OTROS":"0","TOTAL_USD":"24842.12"},{"CODE":9,"VENDEDOR":"MAMANI ESTRADA FREDDY BLADIMIR","Columna1":null,"CC":"LPZ","CONTADO":"19161.10","CREDITO":"5022.76","ANTICIPO":"84527.96","OTROS":"0","NOTAS_CREDITO":"0","DEVOLUCIONES_OTROS":"0","TOTAL_USD":"108711.82"},{"CODE":67,"VENDEDOR":"MARISCAL FLORES FERNANDA","Columna1":null,"CC":"CBBA","CONTADO":"12102.46","CREDITO":"0","ANTICIPO":"881.36","OTROS":"0","NOTAS_CREDITO":"0","DEVOLUCIONES_OTROS":"0","TOTAL_USD":"12983.82"},{"CODE":36,"VENDEDOR":"MENDEZ STEINBACH MAURICIO","Columna1":null,"CC":"CENT","CONTADO":"38387.18","CREDITO":"35273.72","ANTICIPO":"0","OTROS":"0","NOTAS_CREDITO":"0","DEVOLUCIONES_OTROS":"0","TOTAL_USD":"73660.90"},{"CODE":61,"VENDEDOR":"NU\u00d1EZ ZANKYZ JOSE CARLO","Columna1":null,"CC":"BUSH","CONTADO":"12379.12","CREDITO":"0","ANTICIPO":"19917.41","OTROS":"0","NOTAS_CREDITO":"0","DEVOLUCIONES_OTROS":"0","TOTAL_USD":"32296.53"},{"CODE":19,"VENDEDOR":"PACHECO ROCA MERCEDES","Columna1":null,"CC":"CENT","CONTADO":"46746.76","CREDITO":"9552.34","ANTICIPO":"27888.81","OTROS":"0","NOTAS_CREDITO":"0","DEVOLUCIONES_OTROS":"188.39","TOTAL_USD":"83999.52"},{"CODE":16,"VENDEDOR":"PAREJAS BALDERRAMA OLNEY","Columna1":null,"CC":"CENT","CONTADO":"209210.27","CREDITO":"128255.80","ANTICIPO":"2997.48","OTROS":"0","NOTAS_CREDITO":"0","DEVOLUCIONES_OTROS":"0","TOTAL_USD":"340463.55"},{"CODE":17,"VENDEDOR":"PAREJAS CRONEMBOLD JUAN MARIO","Columna1":null,"CC":"CENT","CONTADO":"81467.73","CREDITO":"20395.00","ANTICIPO":"0","OTROS":"0","NOTAS_CREDITO":"0","DEVOLUCIONES_OTROS":"0","TOTAL_USD":"101862.73"},{"CODE":26,"VENDEDOR":"PE\u00d1A LEON ANA INGRID","Columna1":null,"CC":"KM9","CONTADO":"7902.72","CREDITO":"49","ANTICIPO":"35131.61","OTROS":"0","NOTAS_CREDITO":"0","DEVOLUCIONES_OTROS":"0","TOTAL_USD":"43083.33"},{"CODE":62,"VENDEDOR":"ROCA MAMMAMA OSCAR ALCIBIADES","Columna1":null,"CC":"CENT","CONTADO":"28241.17","CREDITO":"37744.00","ANTICIPO":"0","OTROS":"0","NOTAS_CREDITO":"0","DEVOLUCIONES_OTROS":"0","TOTAL_USD":"65985.17"},{"CODE":35,"VENDEDOR":"SEAS HURTADO ADILIR","Columna1":null,"CC":"CENT","CONTADO":"2072.00","CREDITO":"0","ANTICIPO":"0","OTROS":"0","NOTAS_CREDITO":"0","DEVOLUCIONES_OTROS":"0","TOTAL_USD":"2072.00"},{"CODE":21,"VENDEDOR":"TUM-PAR","Columna1":null,"CC":"CENT","CONTADO":"3035.59","CREDITO":"13735.47","ANTICIPO":"4991.21","OTROS":"0","NOTAS_CREDITO":"0","DEVOLUCIONES_OTROS":"17067.20","TOTAL_USD":"4695.07"},{"CODE":8,"VENDEDOR":"VACA ORTIZ YULIO ANTONIO","Columna1":null,"CC":"PROY","CONTADO":"7084.65","CREDITO":"10668.15","ANTICIPO":"3190.58","OTROS":"0","NOTAS_CREDITO":"0","DEVOLUCIONES_OTROS":"0","TOTAL_USD":"20943.38"},{"CODE":49,"VENDEDOR":"VEGA AYALA CHRISTIAN","Columna1":null,"CC":"CUS","CONTADO":"7378.33","CREDITO":"0","ANTICIPO":"0","OTROS":"0","NOTAS_CREDITO":"0","DEVOLUCIONES_OTROS":"0","TOTAL_USD":"7378.33"},{"CODE":44,"VENDEDOR":"VILLAVICENCIO JOSELINE","Columna1":null,"CC":"CENT","CONTADO":"11598.16","CREDITO":"488990.04","ANTICIPO":"69661.48","OTROS":"0","NOTAS_CREDITO":"4753.44","DEVOLUCIONES_OTROS":"0","TOTAL_USD":"565496.24"},{"CODE":12,"VENDEDOR":"VILLAVICENCIO STEINBACH NELSON","Columna1":null,"CC":"CENT","CONTADO":"46805.58","CREDITO":"33721.41","ANTICIPO":"0.28","OTROS":"0","NOTAS_CREDITO":"0","DEVOLUCIONES_OTROS":"0","TOTAL_USD":"80527.27"}]
  res.json(TablaTOT);
});

router.post('/b1s/v1/TablaDet', (req, res) => {
  const TablaDET = [{"SlpCode":37,"SlpName":"-","U_CentroCosto":null},{"SlpCode":55,"SlpName":"ALARCON SERGIO EDUARDO","U_CentroCosto":"LPZ"},{"SlpCode":60,"SlpName":"ARE MORALES YVANISSE","U_CentroCosto":"CENT"},{"SlpCode":6,"SlpName":"ARTEAGA MONTERO MAURICE ANGEL","U_CentroCosto":"BUSH"},{"SlpCode":64,"SlpName":"BARRIENTOS MUCARZEL VALENTINA JOSE","U_CentroCosto":"CENT"},{"SlpCode":43,"SlpName":"BEDREGAL RAUL","U_CentroCosto":null},{"SlpCode":51,"SlpName":"BEDREGAL SANJINES ARTURO FABRICIO","U_CentroCosto":"LPZ"},{"SlpCode":42,"SlpName":"BEDREGAL SANJINES CARLOS ANDRES","U_CentroCosto":"LPZ"},{"SlpCode":10,"SlpName":"BOSQUE ILLANES ERICK REYNALDO","U_CentroCosto":null},{"SlpCode":30,"SlpName":"BUENAVEREZ VASQUEZ MARIA DEL CARMEN","U_CentroCosto":null},{"SlpCode":25,"SlpName":"CABRERA ROCA LIZZY","U_CentroCosto":"CENT"},{"SlpCode":54,"SlpName":"CAMACHO BELMONTE RODRIGO JOSE","U_CentroCosto":"LPZ"},{"SlpCode":63,"SlpName":"CARDOZO VEGA ANA BELEN","U_CentroCosto":"CBBA"},{"SlpCode":31,"SlpName":"CASTEDO JAVIER","U_CentroCosto":null},{"SlpCode":18,"SlpName":"CASTRO CUELLAR JOANA","U_CentroCosto":"CENT"},{"SlpCode":68,"SlpName":"CAYO YA\u00d1EZ CARLA ANELIZ","U_CentroCosto":"CBBA"},{"SlpCode":48,"SlpName":"CHALE MORALES MARIANA","U_CentroCosto":"CUS"},{"SlpCode":2,"SlpName":"COLLAZOS VARGAS ROSELVINA","U_CentroCosto":"BUSH"},{"SlpCode":40,"SlpName":"CUELLAR ANGULO JULIO CESAR","U_CentroCosto":"CENT"},{"SlpCode":32,"SlpName":"CUELLAR PEREZ SANDRO","U_CentroCosto":null},{"SlpCode":24,"SlpName":"DECKER CABEZA KAREN NICOLE","U_CentroCosto":null},{"SlpCode":39,"SlpName":"ESPINOZA BURGOS LILIANA","U_CentroCosto":null},{"SlpCode":58,"SlpName":"FIGUEROA POMAR PATRICIA","U_CentroCosto":"LPZ"},{"SlpCode":29,"SlpName":"FLORES GUARDIA DANIELA","U_CentroCosto":"CENT"},{"SlpCode":11,"SlpName":"FLORES RODRIGUEZ ROSARIO ERIKA","U_CentroCosto":null},{"SlpCode":7,"SlpName":"FLORES SAUCEDO PABLO FERNANDO","U_CentroCosto":"PROY"},{"SlpCode":3,"SlpName":"GALINDO GIL AIMETT ALEJANDRA","U_CentroCosto":"CENT"},{"SlpCode":38,"SlpName":"HIZA MENACHO SARA YAMILE","U_CentroCosto":"CENT"},{"SlpCode":5,"SlpName":"HOYOS ARAUZ PABLO LEONIDAS","U_CentroCosto":"DIST"},{"SlpCode":66,"SlpName":"ILLANES VERA CINTHYA MARIANA","U_CentroCosto":"LPZ"},{"SlpCode":28,"SlpName":"LANDIVAR ANTEZANA MARIA REGINA","U_CentroCosto":"CENT"},{"SlpCode":27,"SlpName":"LAZO DUABYAKOSKY ANA MARIA","U_CentroCosto":"CENT"},{"SlpCode":65,"SlpName":"LLANOS MOLINA MARIA FERNANDA","U_CentroCosto":"KM9"},{"SlpCode":9,"SlpName":"MAMANI ESTRADA FREDDY BLADIMIR","U_CentroCosto":"LPZ"},{"SlpCode":67,"SlpName":"MARISCAL FLORES FERNANDA","U_CentroCosto":"CBBA"},{"SlpCode":13,"SlpName":"MELGAR TERRAZAS JUAN PABLO","U_CentroCosto":null},{"SlpCode":36,"SlpName":"MENDEZ STEINBACH MAURICIO","U_CentroCosto":"CENT"},{"SlpCode":50,"SlpName":"MIRANDA PANDO CARLOS EDUARDO","U_CentroCosto":"LPZ"},{"SlpCode":61,"SlpName":"NU\u00d1EZ ZANKYZ JOSE CARLO","U_CentroCosto":"BUSH"},{"SlpCode":45,"SlpName":"PACHECO GABRIELA","U_CentroCosto":null},{"SlpCode":19,"SlpName":"PACHECO ROCA MERCEDES","U_CentroCosto":"CENT"},{"SlpCode":16,"SlpName":"PAREJAS BALDERRAMA OLNEY","U_CentroCosto":"CENT"},{"SlpCode":17,"SlpName":"PAREJAS CRONEMBOLD JUAN MARIO","U_CentroCosto":"CENT"},{"SlpCode":14,"SlpName":"PAREJAS CRONEMBOLD WALTER HECTOR","U_CentroCosto":"CENT"},{"SlpCode":22,"SlpName":"PAREJAS ROMAN JAIME","U_CentroCosto":null},{"SlpCode":26,"SlpName":"PE\u00d1A LEON ANA INGRID","U_CentroCosto":"KM9"},{"SlpCode":33,"SlpName":"PONCE HUAMAN RONALD","U_CentroCosto":null},{"SlpCode":15,"SlpName":"RIVAS JUSTINIANO RONALD","U_CentroCosto":"CENT"},{"SlpCode":59,"SlpName":"ROCA HUMEREZ JOSE ISRAEL","U_CentroCosto":"LPZ"},{"SlpCode":62,"SlpName":"ROCA MAMMAMA OSCAR ALCIBIADES","U_CentroCosto":"CENT"},{"SlpCode":35,"SlpName":"SEAS HURTADO ADILIR","U_CentroCosto":"CENT"},{"SlpCode":41,"SlpName":"SOLAR MARAZ ROGER","U_CentroCosto":"CENT"},{"SlpCode":53,"SlpName":"SORIA C. LUIS ALBERTO","U_CentroCosto":"DIST"},{"SlpCode":4,"SlpName":"SUAREZ SUAREZ MARIA LAURA","U_CentroCosto":"CENT"},{"SlpCode":34,"SlpName":"TAMBO GOMEZ DIEGO GABRIEL","U_CentroCosto":null},{"SlpCode":21,"SlpName":"TUM-PAR","U_CentroCosto":"CENT"},{"SlpCode":52,"SlpName":"TUM-PAR LA PAZ","U_CentroCosto":"LPZ"},{"SlpCode":8,"SlpName":"VACA ORTIZ YULIO ANTONIO","U_CentroCosto":"PROY"},{"SlpCode":23,"SlpName":"VACA VACA VICTOR HUGO","U_CentroCosto":null},{"SlpCode":56,"SlpName":"VAN KERCKHOVE PATRICK","U_CentroCosto":"LPZ"},{"SlpCode":57,"SlpName":"VARGAS NAVIA DANIELA ENA","U_CentroCosto":"LPZ"},{"SlpCode":49,"SlpName":"VEGA AYALA CHRISTIAN","U_CentroCosto":"CUS"},{"SlpCode":44,"SlpName":"VILLAVICENCIO JOSELINE","U_CentroCosto":"CENT"},{"SlpCode":12,"SlpName":"VILLAVICENCIO STEINBACH NELSON","U_CentroCosto":"CENT"},{"SlpCode":47,"SlpName":"ZAMBRANA MARQUEZ MAURICIO GABRIEL","U_CentroCosto":null},{"SlpCode":46,"SlpName":"ZEGARRA MAURICIO","U_CentroCosto":null}]
  res.json(TablaDET);
});

router.post('/b1s/v1/TablaU', (req, res) => {
  const TablaU = [{"SlpCode":37,"SlpName":"-","U_CentroCosto":null},{"SlpCode":55,"SlpName":"ALARCON SERGIO EDUARDO","U_CentroCosto":"LPZ"},{"SlpCode":60,"SlpName":"ARE MORALES YVANISSE","U_CentroCosto":"CENT"},{"SlpCode":6,"SlpName":"ARTEAGA MONTERO MAURICE ANGEL","U_CentroCosto":"BUSH"},{"SlpCode":64,"SlpName":"BARRIENTOS MUCARZEL VALENTINA JOSE","U_CentroCosto":"CENT"},{"SlpCode":43,"SlpName":"BEDREGAL RAUL","U_CentroCosto":null},{"SlpCode":51,"SlpName":"BEDREGAL SANJINES ARTURO FABRICIO","U_CentroCosto":"LPZ"},{"SlpCode":42,"SlpName":"BEDREGAL SANJINES CARLOS ANDRES","U_CentroCosto":"LPZ"},{"SlpCode":10,"SlpName":"BOSQUE ILLANES ERICK REYNALDO","U_CentroCosto":null},{"SlpCode":30,"SlpName":"BUENAVEREZ VASQUEZ MARIA DEL CARMEN","U_CentroCosto":null},{"SlpCode":25,"SlpName":"CABRERA ROCA LIZZY","U_CentroCosto":"CENT"},{"SlpCode":54,"SlpName":"CAMACHO BELMONTE RODRIGO JOSE","U_CentroCosto":"LPZ"},{"SlpCode":63,"SlpName":"CARDOZO VEGA ANA BELEN","U_CentroCosto":"CBBA"},{"SlpCode":31,"SlpName":"CASTEDO JAVIER","U_CentroCosto":null},{"SlpCode":18,"SlpName":"CASTRO CUELLAR JOANA","U_CentroCosto":"CENT"},{"SlpCode":68,"SlpName":"CAYO YA\u00d1EZ CARLA ANELIZ","U_CentroCosto":"CBBA"},{"SlpCode":48,"SlpName":"CHALE MORALES MARIANA","U_CentroCosto":"CUS"},{"SlpCode":2,"SlpName":"COLLAZOS VARGAS ROSELVINA","U_CentroCosto":"BUSH"},{"SlpCode":40,"SlpName":"CUELLAR ANGULO JULIO CESAR","U_CentroCosto":"CENT"},{"SlpCode":32,"SlpName":"CUELLAR PEREZ SANDRO","U_CentroCosto":null},{"SlpCode":24,"SlpName":"DECKER CABEZA KAREN NICOLE","U_CentroCosto":null},{"SlpCode":39,"SlpName":"ESPINOZA BURGOS LILIANA","U_CentroCosto":null},{"SlpCode":58,"SlpName":"FIGUEROA POMAR PATRICIA","U_CentroCosto":"LPZ"},{"SlpCode":29,"SlpName":"FLORES GUARDIA DANIELA","U_CentroCosto":"CENT"},{"SlpCode":11,"SlpName":"FLORES RODRIGUEZ ROSARIO ERIKA","U_CentroCosto":null},{"SlpCode":7,"SlpName":"FLORES SAUCEDO PABLO FERNANDO","U_CentroCosto":"PROY"},{"SlpCode":3,"SlpName":"GALINDO GIL AIMETT ALEJANDRA","U_CentroCosto":"CENT"},{"SlpCode":38,"SlpName":"HIZA MENACHO SARA YAMILE","U_CentroCosto":"CENT"},{"SlpCode":5,"SlpName":"HOYOS ARAUZ PABLO LEONIDAS","U_CentroCosto":"DIST"},{"SlpCode":66,"SlpName":"ILLANES VERA CINTHYA MARIANA","U_CentroCosto":"LPZ"},{"SlpCode":28,"SlpName":"LANDIVAR ANTEZANA MARIA REGINA","U_CentroCosto":"CENT"},{"SlpCode":27,"SlpName":"LAZO DUABYAKOSKY ANA MARIA","U_CentroCosto":"CENT"},{"SlpCode":65,"SlpName":"LLANOS MOLINA MARIA FERNANDA","U_CentroCosto":"KM9"},{"SlpCode":9,"SlpName":"MAMANI ESTRADA FREDDY BLADIMIR","U_CentroCosto":"LPZ"},{"SlpCode":67,"SlpName":"MARISCAL FLORES FERNANDA","U_CentroCosto":"CBBA"},{"SlpCode":13,"SlpName":"MELGAR TERRAZAS JUAN PABLO","U_CentroCosto":null},{"SlpCode":36,"SlpName":"MENDEZ STEINBACH MAURICIO","U_CentroCosto":"CENT"},{"SlpCode":50,"SlpName":"MIRANDA PANDO CARLOS EDUARDO","U_CentroCosto":"LPZ"},{"SlpCode":61,"SlpName":"NU\u00d1EZ ZANKYZ JOSE CARLO","U_CentroCosto":"BUSH"},{"SlpCode":45,"SlpName":"PACHECO GABRIELA","U_CentroCosto":null},{"SlpCode":19,"SlpName":"PACHECO ROCA MERCEDES","U_CentroCosto":"CENT"},{"SlpCode":16,"SlpName":"PAREJAS BALDERRAMA OLNEY","U_CentroCosto":"CENT"},{"SlpCode":17,"SlpName":"PAREJAS CRONEMBOLD JUAN MARIO","U_CentroCosto":"CENT"},{"SlpCode":14,"SlpName":"PAREJAS CRONEMBOLD WALTER HECTOR","U_CentroCosto":"CENT"},{"SlpCode":22,"SlpName":"PAREJAS ROMAN JAIME","U_CentroCosto":null},{"SlpCode":26,"SlpName":"PE\u00d1A LEON ANA INGRID","U_CentroCosto":"KM9"},{"SlpCode":33,"SlpName":"PONCE HUAMAN RONALD","U_CentroCosto":null},{"SlpCode":15,"SlpName":"RIVAS JUSTINIANO RONALD","U_CentroCosto":"CENT"},{"SlpCode":59,"SlpName":"ROCA HUMEREZ JOSE ISRAEL","U_CentroCosto":"LPZ"},{"SlpCode":62,"SlpName":"ROCA MAMMAMA OSCAR ALCIBIADES","U_CentroCosto":"CENT"},{"SlpCode":35,"SlpName":"SEAS HURTADO ADILIR","U_CentroCosto":"CENT"},{"SlpCode":41,"SlpName":"SOLAR MARAZ ROGER","U_CentroCosto":"CENT"},{"SlpCode":53,"SlpName":"SORIA C. LUIS ALBERTO","U_CentroCosto":"DIST"},{"SlpCode":4,"SlpName":"SUAREZ SUAREZ MARIA LAURA","U_CentroCosto":"CENT"},{"SlpCode":34,"SlpName":"TAMBO GOMEZ DIEGO GABRIEL","U_CentroCosto":null},{"SlpCode":21,"SlpName":"TUM-PAR","U_CentroCosto":"CENT"},{"SlpCode":52,"SlpName":"TUM-PAR LA PAZ","U_CentroCosto":"LPZ"},{"SlpCode":8,"SlpName":"VACA ORTIZ YULIO ANTONIO","U_CentroCosto":"PROY"},{"SlpCode":23,"SlpName":"VACA VACA VICTOR HUGO","U_CentroCosto":null},{"SlpCode":56,"SlpName":"VAN KERCKHOVE PATRICK","U_CentroCosto":"LPZ"},{"SlpCode":57,"SlpName":"VARGAS NAVIA DANIELA ENA","U_CentroCosto":"LPZ"},{"SlpCode":49,"SlpName":"VEGA AYALA CHRISTIAN","U_CentroCosto":"CUS"},{"SlpCode":44,"SlpName":"VILLAVICENCIO JOSELINE","U_CentroCosto":"CENT"},{"SlpCode":12,"SlpName":"VILLAVICENCIO STEINBACH NELSON","U_CentroCosto":"CENT"},{"SlpCode":47,"SlpName":"ZAMBRANA MARQUEZ MAURICIO GABRIEL","U_CentroCosto":null},{"SlpCode":46,"SlpName":"ZEGARRA MAURICIO","U_CentroCosto":null}]
  res.json(TablaU);
});

// Exportamos el router de Express
export default router;
