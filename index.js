const express = require('express')
const morgan = require('morgan')
const cors = require('cors')
const bodyparser = require('body-parser')

const app = express()

// middlewares 
app.use(morgan('dev'))
app.use(bodyparser.json())
app.use(cors())
require('dotenv').config()

// routes
app.use('/api/', require('./routes/user'))

// route para reportes
app.use('/api/', require('./routes/report'))

// route para eventos
app.use('/api/', require('./routes/event'))

// rute para clientes 
app.use('/api/', require('./routes/client'))

// rute para validador de ventanilla
app.use('/api/', require('./routes/valVentanilla'))

// port
const port = process.env.PORT
// port para manejar error 404
app.use(function(req, res, nex){
    res.status(404).send('Lo lamentamos, la ruta que seleciono no existe')
})

// listen.port
app.listen(port,() =>{
    console.log(`Aplicación de MySQL corriendo en el puerto ${port}`)
})