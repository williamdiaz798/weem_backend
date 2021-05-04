const pool = require('../pool')
const sql = require('../sql/userQuerys')
const tocken = '66b86305034d4827fce965b4e246ff62545c6d4db3701138cca4e1b648583ec6'
exports.getUsers = async (req, res) => {
    const data = req.body
    try{
        
        if(data.tocken == tocken){
            pool.query('call lista_usuarios()',(err, response) =>{
                if(err) throw err
                if(response[0].length)
                    res.json(response[0])
                res.end()
            })
        }else{
            res.json({error: 'No posee acceso a esta pagina'})
        }
        
    }catch (error){
        return res.json(error)
    }
}

exports.login = async (req, res) => {
    let data = req.body
    var datos
    try{
        pool.query(`call login_local_users("${data.correo}","${data.clave}")`,(err, response) =>{
            if(err) throw err
            if(response[0].length){
                response[0].forEach(user => {
                    if(user.estado_usuario == 'ACTIVO' ){
                        res.json({login: true,tocken: tocken, tipoUsuario: user.id_tipo_usuario, nombreUsuario: user.nombre_usuario, correoUsuario: user.correo_usuario, idtipoSesion: user.tipo_sesion_usuario, telefonoUsuario: user.telefono_usuario})
                        datos = {login: true,tocken: tocken, tipoUsuario: user.id_tipo_usuario, nombreUsuario: user.nombre_usuario, correoUsuario: user.correo_usuario, idtipoSesion: user.tipo_sesion_usuario, telefonoUsuario: user.telefono_usuario}
                    }else{
                        res.json({login: 'Este usuario esta inhabilitado'})
                        console.log(response[0].correo_usuario)
                    }
                });
            }
            else{
                res.json({login: 'Error de credenciales'})
            }
            res.end()
            console.log(datos)
        })
    }catch (error){
        return res.json(error)
    }
}


exports.crearUsuario = async (req, res) => {
    let data = req.body
    console.log(data)
    try{
        
        if(data.tocken = tocken){
            pool.query(`call usuario_por_correo('${data.correoUsuario}')`,(err, valCorreo) =>{
                if(err) throw err
                if(valCorreo[0].length > 0){ 
                    valCorreo[0].forEach(user => {
                        res.json({tocken: tocken,crearUsuario: 'Error!!!, el correo ya esta en uso', idtipoSesion: user.tipo_sesion_usuario,tipoUsuario: user.tipoUsuario})
                    })
                }else{
                    //console.log(`call insertar_usuario_local("${data.nombreUsuario}","${data.correoUsuario}","${data.claveUsuario}","${data.tipoUsuario}","${data.idtipoSesion}","${data.telefonoUsuario}")`)
                    pool.query(`call insertar_usuario_local("${data.nombreUsuario}","${data.correoUsuario}","${data.claveUsuario}","${data.tipoUsuario}","${data.idtipoSesion}","${data.telefonoUsuario}")`,(err, response) =>{
                        console.log(`call insertar_usuario_local("${data.nombreUsuario}","${data.correoUsuario}","${data.claveUsuario}","${data.tipoUsuario}","${data.idtipoSesion}","${data.telefonoUsuario}")`)
                        if(err) {
                            res.json({crearUsuario: 'Error de al almacenar los datos'})
                            //throw err
                        }else{
                            res.json({crearUsuario: true,tocken: tocken})
                        }
                        res.end()
                    }) 
                }
            })
        }else{
            res.json({error: 'No posee acceso a esta pagina'})
        }
        
    }catch (error){
        return res.json(error)
    }
}


exports.editarUsuario = async (req, res) => {
    let data = req.body
    console.log(data)
    try{
        pool.query(`call editar_usuario_local("${data.nombreUsuario}","${data.correoUsuario}","${data.claveUsuario}","${data.tipoUsuario}")`,(err, response) =>{
            console.log(`call editar_usuario_local("${data.nombreUsuario}","${data.correoUsuario}","${data.claveUsuario}","${data.tipoUsuario}")`)
            if(err) {
                res.json({editarUsuario: 'Error de al almacenar los datos'})
                //throw err
            }else{
                res.json({editarUsuario: true})
            }
            res.end()
        }) 
        
    }catch (error){
        return res.json(error)
    }
}

exports.usuarioPorCorreo= async (req, res)=>{
    var data = req.body
    console.log(data.correoUsuario)
    try{
        pool.query(`call usuario_por_correo('${data.correoUsuario}')`,(err, valCorreo) =>{
            if(err) throw err
            if(valCorreo[0].length > 0){
                res.json(valCorreo[0])
            }

        })
    }catch (error){
        console.log(error)
    }
}

exports.tipoUsuario = async (req, res) => {
    const data = req.body
    try{
        if(data.tocken == tocken){
            pool.query('call lista_tipos_usuarios()',(err, response) =>{
                if(err) throw err
                if(response[0].length)
                    res.json(response[0])
                res.end()
            })
        }else{
            res.json({error: 'No posee acceso a esta pagina'})
        }
        
    }catch (error){
        return res.json(error)
    }
}

exports.estadoUsuario = async (req, res) => {
    let data = req.body
    try{
        var estadousuario2 = data.estadoUsuario
        console.log(estadousuario2)
        if(estadousuario2 == 'ACTIVO'){
            pool.query(`call cambiar_estado_usuario_local_2("${data.correoUsuario}", "INHABILITADO")`,(err, response) =>{
                console.log(`call cambiar_estado_usuario_local_2("${data.correoUsuario}", "INHABILITADO")`)
                if(err) {
                    res.json({success: 'Error al cambiar el estado'})
                    console.log('error')
                }
                else{
                    res.json({success: true})
                }
                res.end()
            })
        }else{
            pool.query(`call cambiar_estado_usuario_local_2("${data.correoUsuario}", "ACTIVO")`,(err, response) =>{
                if(err) {
                    res.json({success: 'Error al cambiar el estado'})
                    console.log('error')
                }
                else{
                    res.json({success: true})
                }
                res.end()
            })
        }
        
    }catch (error){
        return res.json(error)
    }
}


exports.insertar_telefono = async (req, res) => {
    let data = req.body
    try{
        
        pool.query(`call insertar_telefono('${data.telefonoUsuario}', '${data.correoUsuario}')`,(err, response) =>{
            //console.log(`call insertar_usuario_local("${data.nombreUsuario}","${data.correoUsuario}","${data.claveUsuario}","${data.tipoUsuario}","${data.idtipoSesion}")`)
            if(err) {
                res.json({crearTelfono: 'Error de al almacenar los datos'})
                //throw err
            }else{
                res.json({crearTelfono: true})
            }
            res.end()
        }) 
          
        
    }catch (error){
        return res.json(error)
    }
}