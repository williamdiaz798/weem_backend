const express = require('express')
const router = express.Router()

const { getUsers, 
    login, 
    crearUsuario, 
    tipoUsuario,
    estadoUsuario,
    usuarioPorCorreo,
    editarUsuario,
    insertar_telefono
} = require('../controller/userController')

router.post('/users', getUsers)
router.post('/tipoUsuario', tipoUsuario)
router.post('/login', login)
router.post('/crearUsuario', crearUsuario)
router.post('/editarUsuario', editarUsuario)
router.post('/estadoUsuario', estadoUsuario)
router.post('/usuarioPorCorreo', usuarioPorCorreo)
router.post('/insertar_telefono', insertar_telefono)


module.exports = router