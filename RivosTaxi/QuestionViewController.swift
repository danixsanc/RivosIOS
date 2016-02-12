//
//  QuestionViewController.swift
//  RivosTaxi
//
//  Created by Ramón Quiñonez on 29/01/16.
//  Copyright © 2016 Yozzi Been's. All rights reserved.
//

import UIKit

class QuestionViewController: UIViewController, UITableViewDataSource,UITableViewDelegate {
    
    var mycell:MyTableViewCell!
    let p1 = "¿Cómo solicito un taxi?"
    let p2 = "¿Dónde puedo ver mi informacion personal?"
    let p3 = "¿Puedo editar mi perfil?"
    let p4 = "¿Cómo agrego mis lugares favoritos?"
    let p5 = "¿Cómo utilizo mis lugares favoritos?"

    
    
    
    
    
    var menuItems:[String] = [];
    //var menuIcons = ["ic_flight_takeoff", "ic_flight_land", "ic_attach_money"];

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //itemsTable
        menuItems.insert(p1, atIndex: 0)
        menuItems.insert(p2, atIndex: 1)
        menuItems.insert(p3, atIndex: 2)
        menuItems.insert(p4, atIndex: 3)
        menuItems.insert(p5, atIndex: 4)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func Cancel(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //Table functions
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        return menuItems.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        mycell = tableView.dequeueReusableCellWithIdentifier("MyCellQuestion", forIndexPath: indexPath) as! MyTableViewCell
        
        //var bleachimage = UIImage(named: menuIcons[indexPath.row])
        //mycell.imageView?.image  = bleachimage
        
        mycell.question_answer.text = menuItems[indexPath.row]
        
        
        return mycell;
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        
        
        switch(indexPath.row)
        {
            
        case 0:
            
            let alert = UIAlertView()
            alert.title = "¿Cómo solicito un taxi?"
            alert.message = "La primer ventana que te aparece en la aplicación es la que necesitas para pedir un taxi; lo primero que debes hacer es mover el cursor de selección de destino (color gris) desplazándolo hasta el punto a donde te quieres trasladar, o bien, escribiendo la direccion en el cuadro de texto de la parte superior de la pantalla. Una vez seleccionado tu destino daras click en el boton de pedir taxi (boton azul con el ícono de un taxi) se solicitará que confirmes ubicación y proporciones tu tarjeta de credito."
            alert.addButtonWithTitle("Ok")
            alert.show()
            
            
            break;
            
        case 1:
            let alert = UIAlertView()
            alert.title = "¿Dónde puedo ver mi informacion personal?"
            alert.message = "Una vez dentro de la aplicación desliza tu dedo en la pantalla de izquierda a derecha, se abrirá un menú, dentro de éste hay una sección 'Perfil', da click y ahí mismo puedes ver tu información personal."
            alert.addButtonWithTitle("Ok")
            alert.show()
            
            

            break;
            
            
        case 2:
            let alert = UIAlertView()
            alert.title = "¿Puedo editar mi perfil?"
            alert.message = "En la sección perfil de la aplicacion, en la parte inferior a un boton que dice 'modificar datos', al darle clic se te enviara un codigo de verificación a tu correo electrónico, lo anotas en donde dice 'código' y podrás modificar tus datos."
            alert.addButtonWithTitle("Ok")
            alert.show()
            
            

            break;
       
        case 3:
            let alert = UIAlertView()
            alert.title = "¿Cómo agrego mis lugares favoritos?"
            alert.message = "Entra a la sección de 'favoritos', ya una vez ahí, darás clic donde dice 'lugares', una vez dentro verás en la parte inferior un botón con un signo de '+', le das clic y ahí dentro escoges el lugar que deseas"
            alert.addButtonWithTitle("Ok")
            alert.show()
            
            

            break;
            
            
        case 4:
            let alert = UIAlertView()
            alert.title = "¿Cómo utilízo mis lugares favoritos?"
            alert.message = "En la primera ventana de la aplicación, arriba del botón para solicitar taxistas, está otro botón con un cursor de selección (color azul oscuro), le das clic y ahí mismo te aparecen los lugares favoritos que tienes registrados. Sólo basta con seleccionarlo para proceder a pedir el taxi."
            alert.addButtonWithTitle("Ok")
            alert.show()
            
            

            break;

            
        default:
            print("\(menuItems[indexPath.row]) is selected");
            
        }
        
    }
    
    //end
    
/*let vc = TwoViewController(nibName: "TwoViewController", bundle: nil)
navigationController?.pushViewController(vc, animated: true)*/
}
