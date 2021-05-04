const express = require('express')
const router = express.Router()

const { 
    getEventosAdmin,
    getEventoDetalle,
    crearEvento,
    eventosPorAdminTotales,
    reservarPorEventoAdmin,
    editarEvento,
    cambiarEstadoEvento,
    eliminarEvento,
    getEventos
} = require('../controller/eventController')

router.post('/eventosPorAdmin/', getEventosAdmin)
router.post('/eventoDetalle/', getEventoDetalle)
router.post('/crearEvento/', crearEvento)
router.post('/editarEvento/', editarEvento)
router.post('/eliminarEvento/', eliminarEvento)
router.post('/cambiarEstadoEvento/', cambiarEstadoEvento)
router.post('/eventosPorAdminTotales/', eventosPorAdminTotales)
router.post('/reservarPorEventoAdmin/', reservarPorEventoAdmin)
router.post('/eventos/', getEventos)

module.exports = router