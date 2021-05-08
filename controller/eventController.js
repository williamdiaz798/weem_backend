const accountSid = 'AC9e7f5ae3ccda17dcb30dc6f96a46d22a'; 
const authToken = '602bd3c9401c4ec76c7698a85f8dfe05';
const client = require('twilio')(accountSid, authToken)

const pool = require('../pool')

const tocken = '66b86305034d4827fce965b4e246ff62545c6d4db3701138cca4e1b648583ec6'
exports.getEventosAdmin = async (req, res) => {
    var data = req.body
    try{
        if(data.tocken == tocken){
            pool.query('call eventos_por_admin_lista("'+data.correoUsuario+'")',(err, response) =>{
                if(err) throw err
                if(response[0].length)
                    res.json(response[0])
                res.end()
            })
        }else{
            res.json({error: 'No tiene acceso a esta pagina'})
        }
        
    }catch (error){
        return res.json(error)
    }
}

exports.getEventos = async (req, res) => {
    var data = req.body
    try{
        if(data.tocken == tocken){
            pool.query('call lista_eventos()',(err, response) =>{
                if(err) throw err
                if(response[0].length)
                    res.json(response[0])
                res.end()
            })
        }else{
            res.json({error: 'No tiene acceso a esta pagina'})
        }
        
    }catch (error){
        return res.json(error)
    }
}

exports.getEventoDetalle = async (req, res) => {
    var data = req.body
    try{
        if(data.tocken == tocken){
            pool.query('call evento_por_id("'+data.idEvento+'")',(err, response) =>{
                if(err) throw err
                if(response[0].length){
                    res.json(response[0])
                }                    
                res.end()
            })
        }else{
            res.json({error: 'No tiene acceso a esta pagina'})
        }
        
    }catch (error){
        return res.json(error)
    }
}

exports.crearEvento = async (req, res) => {
    var data = req.body
    var idEvento = ''
    var idNunEvento
    //console.log(data)
    try{
        if(data.tocken == tocken){
            // funcion para cargar todos los eventos anteriores
                pool.query('call contar_tipo_evento('+data.tipoEvento+')',(err, response) =>{
                //console.log('call contar_tipo_evento('+data.tipoEvento+')')
                if(err) throw err
                if(response[0].length)
                {
                    response[0].forEach(evento => {
                        idNunEvento = parseInt(evento.id)
                        if(data.tipoEvento == 1){
                            idEvento = 'P'+(idNunEvento+1)
                        }else{
                            idEvento = 'V'+(idNunEvento+1)
                        }
                    })
                }else{
                    if(data.tipoEvento == 1){
                        idEvento = 'P1'
                    }else{
                        idEvento = 'V1'
                    }
                }
                console.log('call crear_evento("'+idEvento+'","'+data.nombreEvento+'","'+data.fechaEvento+' '+data.horaEvento+'","'+data.direccionEvento+'", '+data.coordenada_x+', '+data.coordenada_y+' , '+data.entradasTotalesEvento+', 0, 0, '+data.entradasPrecioEvento+', '+data.tipoEvento+', "'+data.nombreusuario+'")')
                pool.query('call crear_evento("'+idEvento+'","'+data.nombreEvento+'","'+data.fechaEvento+' '+data.horaEvento+'","'+data.direccionEvento+'", '+data.coordenada_x+', '+data.coordenada_y+' , '+data.entradasTotalesEvento+', 0, 0, '+data.entradasPrecioEvento+', '+data.tipoEvento+', "'+data.nombreusuario+'")',(err2, response2) =>{
                    console.log('call crear_evento("'+idEvento+'","'+data.nombreEvento+'","'+data.fechaEvento+' '+data.horaEvento+'","'+data.direccionEvento+'", '+data.coordenada_x+', '+data.coordenada_y+' , '+data.entradasTotalesEvento+', 0, 0, '+data.entradasPrecioEvento+', '+data.tipoEvento+', "'+data.nombreusuario+'")')
                    if(err2) {
                        res.json({respuesta: 'incorrecto'})
                    }
                    if(response2)
                    {
                        res.json({respuesta: 'correcto'})
                    }else{
                        res.json({respuesta: 'incorrecto'})
                    }
                    res.end()
                })
            })
        }else{
            res.json({error: 'No tiene acceso a esta pagina'})
        }
        
    }catch (error){
        return res.json(error)
    }
}


exports.editarEvento = async (req, res) => {
    var data = req.body
    try{
        if(data.tocken == tocken){
            pool.query('call actualizar_evento("'
            +data.id_evento+'","'
            +data.nombre_evento+'","'
            +data.fecha_evento+' '
            +data.hora_evento+'","'
            +data.direccion_evento+'", '
            +data.coordenada_x+', '
            +data.coordenada_y+', '
            +data.entradas_totales_evento+', '
            +data.precio_entradas_evento+', "'
            +data.id_usuario_creador+'")',(err2, response2) =>{
                console.log('call actualizar_evento("'
                +data.id_evento+'","'
                +data.nombre_evento+'","'
                +data.fecha_evento+' '
                +data.hora_evento+'","'
                +data.direccion_evento+'", '
                +data.coordenada_x+', '
                +data.coordenada_y+', '
                +data.entradas_totales_evento+', '
                +data.precio_entradas_evento+', "'
                +data.id_usuario_creador+'")')
                if(err2) {
                    res.json({respuesta: 'incorrecto'})
                }
                if(response2)
                {
                    res.json({respuesta: 'correcto'})
                }else{
                    res.json({respuesta: 'incorrecto'})
                }
                res.end()
            })
        }else{
            res.json({error: 'No tiene acceso a esta pagina'})
        }
        
    }catch (error){
        return res.json(error)
    }
}

exports.eventosPorAdminTotales = async (req, res) => {
    var data = req.body
    try{
        if(data.tocken == tocken){
            pool.query('call lista_eventos_totales("'+data.correoUsuario+'")',(err, response) =>{
                if(err) throw err
                if(response[0].length)
                    res.json(response[0])
                res.end()
            })
        }else{
            res.json({error: 'No tiene acceso a esta pagina'})
        }
        
    }catch (error){
        return res.json(error)
    }
}

exports.reservarPorEventoAdmin = async (req, res) => {
    var data = req.body
    try{
        if(data.tocken == tocken){
            pool.query('call lista_reservaciones_cliente_admin("'+data.correoUsuario+'")',(err, response) =>{
                console.log('call lista_reservaciones_cliente_admin("'+data.correoUsuario+'")')
                if(err) throw err
                if(response[0].length)
                    res.json(response[0])
                res.end()
            })
        }else{
            res.json({error: 'No tiene acceso a esta pagina'})
        }
        
    }catch (error){
        return res.json(error)
    }
}



exports.cambiarEstadoEvento = async (req, res) => {
    var data = req.body
    var nuevoEstado = 0
    var nombreEstado = ''
    try{
        if(data.tocken == tocken){
            if(data.estadoEvento == 1){
                nuevoEstado = 2
                nombreEstado = 'Oculto'
            }else{
                nuevoEstado = 1
                nombreEstado = 'Visible'
            }
            pool.query('call cambiar_estado_evento("'+data.idEvento+'",'+nuevoEstado+')',(err2, response2) =>{
                if(err2) {
                    res.json({respuesta: 'incorrecto'})
                }
                if(response2)
                {
                    res.json({respuesta: 'correcto', nombreEstado:nombreEstado})
                }else{
                    res.json({respuesta: 'incorrecto'})
                }
                res.end()
            })
        }else{
            res.json({error: 'No tiene acceso a esta pagina'})
        }
        
    }catch (error){
        return res.json(error)
    }
}

exports.eliminarEvento = async (req, res) => {
    var data = req.body
    try{
        if(data.tocken == tocken){
            pool.query('call cambiar_estado_evento("'+data.idEvento+'","3")',(err, response) =>{
                if(err) {
                    res.json({respuesta: 'incorrecto'})
                }
                if(response)
                {
                    pool.query('call cancelar_entradas("'+data.idEvento+'")',(err2, response2) =>{
                        if(err2) {
                            res.json({respuesta: 'incorrecto'})
                        }
                        if(response2)
                        {
                            pool.query('call lista_telefonos_con_reservaciones("'+data.idEvento+'")',(err3, response3) =>{
                                if(err3) {
                                    res.json({respuesta: 'incorrecto'})
                                }
                                if(response3[0])
                                {
                                    response3[0].forEach(datos =>{
                                        if(datos.telefono_usuario != ''){
                                            client.messages.create({
                                                from: 'whatsapp:+14155238886',
                                                to:'whatsapp:'+datos.telefono_usuario,
                                                body:'Estimado usuario: '+datos.nombre_usuario+', el evento: '+datos.nombre_evento+', que reservo para el dia: ' + datos.fecha_evento +' a las: ' + datos.hora_evento + ' ha sido cancelado por el administrador, pase un feliz dia.'
                                            }).then(message => console.log('sid: '+message.sid)).done()
                                        }
                                    })
                                    res.json({respuesta: 'correcto', nombreEstado:'Cancelado'})
                                }else{
                                    res.json({respuesta: 'incorrecto'})
                                }
                                res.end()
                            })
                        }else{
                            res.json({respuesta: 'incorrecto'})
                        }
                    })
                }else{
                    res.json({respuesta: 'incorrecto'})
                }
            })
        }else{
            res.json({error: 'No tiene acceso a esta pagina'})
        }
        
    }catch (error){
        return res.json(error)
    }
}