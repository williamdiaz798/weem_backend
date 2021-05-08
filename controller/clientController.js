const accountSid = 'AC9e7f5ae3ccda17dcb30dc6f96a46d22a'; 
const authToken = '602bd3c9401c4ec76c7698a85f8dfe05';
const client = require('twilio')(accountSid, authToken)

const pool = require('../pool')
const tocken = '66b86305034d4827fce965b4e246ff62545c6d4db3701138cca4e1b648583ec6'

exports.reservacionesPorCliente = async (req, res) => {
    var data = req.body
    try{
        if(data.tocken == tocken){
            pool.query('call reservaciones_cliente_ultima("'+data.correoUsuario+'")',(err, response) =>{
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
exports.reservacionesPorClienteTodas = async (req, res) => {
    var data = req.body
    try{
        if(data.tocken == tocken){
            pool.query('call reservaciones_cliente("'+data.correoUsuario+'")',(err, response) =>{
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

exports.reservacionDetalle = async (req, res) => {
    var data = req.body
    try{
        if(data.tocken == tocken){
            pool.query('call detalle_reservacion_cliente("'+data.idReservacion+'")',(err, response) =>{
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

exports.reservacionEliminar = async (req, res) => {
    var data = req.body
    try{
        if(data.tocken == tocken){
            pool.query('call actualizar_entradas_reservadas_aumentar("'+data.idEvento+'")',(err, response) =>{
                if(err) throw err
                if(response){
                    pool.query('call cancelar_reserva("'+data.idReservacion+'")',(err, response2) =>{
                        if(err) throw err
                        if(response2){
                            res.json({respuesta: 'correcto'})
                        }
                        res.end()
                    })
                }
            })
        }else{
            res.json({error: 'No tiene acceso a esta pagina'})
        }
    }catch (error){
        return res.json(error)
    }
}


exports.reservar = async (req, res) => {
    var data = req.body
    var idSiguiente
    var codigoEntrada
    var numeroRandon = Math.floor(Math.random() * Math.floor(999))
    try{
        if(data.tocken == tocken){

            try{
                // primero se verifica que hayan espacios libres
            pool.query('call eventos_entradas_libres("'+data.idEvento+'")',(err, response) =>{
                if(err) throw err
                if(response[0].length){
                    response[0].forEach(entradas=>{
                        if(entradas.entradas_libres === 0){
                            res.json({error: 'No se puede realizar la reserva, porque el evento no posee entradas libres'})
                        }else{
                            // despues se valida que el usuario no tenga ya una reserva para ese evento
                            pool.query('call reservacion_cliente_evento("'+data.correoUsuario+'","'+data.idEvento+'")',(err, response) =>{
                                if(err) throw err
                                if(response[0].length){
                                    res.json({error: 'Ya posee una reserva a este evento'})
                                }else{
                                    // Se actualizan las entradas
                                    pool.query('call actualizar_entradas_reservadas("'+data.idEvento+'")',(err2, response2) =>{
                                        if(err2) throw err2
                                        if(response2){
                                            // se extraee el ultimo evento para generar un nuevo ID
                                            pool.query('call ultimo_id_reservacion_evento("'+data.idEvento+'")',(err3, response3) =>{
                                                if(err3) throw err3
                            
                                                if(response3){      
                                                    console.log(console.log('call ultimo_id_reservacion_evento("'+data.idEvento+'")'))
                            
                                                    if(response3[0] == null){
                                                        idSiguiente = 1
                                                    }else {
                                                        response3[0].forEach(id => {
                                                            idSiguiente = id.id_nuevo
                                                        });
                                                    }
                                                    codigoEntrada = data.idEvento + idSiguiente + numeroRandon
                                                    //console.log(codigoEntrada)
                                                    pool.query('call crear_reserva("'+data.correoUsuario+'","'+data.idEvento+'", "'+codigoEntrada+'")',(err, response4) =>{
                                                        //console.log('call crear_reserva("'+data.correoUsuario+'","'+data.idEvento+'", "'+codigoEntrada+'")')
                                                        if(err) throw err
                                                        if(response4){      
                                                            pool.query('call evento_por_id("'+data.idEvento+'")',(err5, response5) =>{
                                                                console.log('call evento_por_id("'+data.idEvento+'")')
                                                                if(err5) throw err5
                                                                if(response5[0].length){
                                                                    response5[0].forEach(reserva =>{
                                                                        if(data.telefonoUsuario != ''){
                                                                            if(data.telefonoUsuario != undefined){
                                                                                client.messages.create({
                                                                                    from: 'whatsapp:+14155238886',
                                                                                    to:'whatsapp:'+data.telefonoUsuario,
                                                                                    body:'Estimado usuario: ' + data.nombreUsuario + ', la reserva fue realizada con exito, para el evento: '+ data.nombreEvento +', programado para el dia: '+reserva.fecha_evento+ ', a las: '+ reserva.hora_evento+', en '+reserva.direccion_evento+' y su código de entrada es: '+codigoEntrada
                                                                                }).then(message => console.log('sid: '+message.sid)).done()
                                                                            }
                                                                            console.log(data)
                                                                        }
                                                                    })
                                                                    res.json({respuesta: 'correcto'})
                                                                }
                                                                res.end()
                                                            })
                                                        }
                                                    })
                                                }
                                            })
                                        }
                                    })
                                }
                            })
                        }
                    })
                    
               }
            })
            }catch(e){
                res.json({error: e})
            }
            
        }else{
            res.json({error: 'No tiene acceso a esta pagina'})
        }
        
    }catch (error){
        return res.json(error)
    }
}

