//
//  ViewController.swift
//  ankka_new
//  Ankkatietojen listauksen näkymä ja sen toiminnot
//  Created by Matti Saarela on 24/01/2018.
//  Copyright © 2018 Matti Saarela. All rights reserved.
//

import UIKit

class AnkkaListViewController: UIViewController, UITableViewDataSource {
    final let url = URL(string: serverAddress + "/sightings")
    var ankat = [Ankka]() //Pääankkataulukko

    @IBOutlet weak var orderButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        downloadSightningsJSON()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func downloadSightningsJSON(){
        guard let downloadURL = url else{return} //Tarkistetaan, että osoite on toimiva
        URLSession.shared.dataTask(with: downloadURL) { (data, urlResponse, error) in
            guard let data = data, error == nil, urlResponse != nil else { //Tarkistetaan että data on oikeasti saatu
                let alert = UIAlertController(title: "Download Error", message: "Error occured while downloading data from server", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                    NSLog("Download Error Occured!")
                }))
                self.present(alert, animated: true, completion: nil)
                return
            }
            //Dekoodataan JSON
            do{
                enum DateError: String, Error {
                    case invalidDate
                }
                
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .custom({ (decoder) -> Date in
                    let container = try decoder.singleValueContainer()
                    let dateStr = try container.decode(String.self)
                    let formatter = DateFormatter()

                    //Datassa käytetty päivämäärästandardi
                    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssXXXXX"
                    if let date = formatter.date(from: dateStr) {
                        return date
                    }
                    throw DateError.invalidDate
                })
                let downloaded_ankat = try decoder.decode([Ankka].self, from: data)
                self.ankat = downloaded_ankat
                DispatchQueue.main.async { //Needs to be in main thread for reload data
                    if let order = self.orderButton.title {
                        self.reorderAnkkaTable(order: order)
                    }
                    self.tableView.reloadData() //Reload table
                }
                }catch{
                    let alert = UIAlertController(title: "Decoding Error", message: "Error occured while decoding downloaded data", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                        NSLog("Decoding Error Occured!" + error.localizedDescription)
                    }))
                    self.present(alert, animated: true, completion: nil)
                    return
            }
            }.resume()
        
    }
    
    func reorderAnkkaTable(order: String) {
        //järjestys nousevasti tai laskevasti order-muuttujan mukaan
            ankat.sort { (i0, i1) -> Bool in
                if order == "Descending" {
                    return i0.dateTime > i1.dateTime
                }
                else if order == "Ascending" {
                    return i0.dateTime < i1.dateTime
                }
                return false
            }
        }
    
    func changeOrder() {
        if let order = orderButton.title {
            if order == "Descending" {
                orderButton.title = "Ascending"
                reorderAnkkaTable(order: "Ascending")
            }
            else if order == "Ascending" {
                orderButton.title = "Descending"
                reorderAnkkaTable(order: "Descending")
            }
        }
    }
    
    
    @IBAction func OrderButtonPressed(_ sender: UIBarButtonItem) {
        changeOrder()
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ankat.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AnkkaCell") as? AnkkaCell else {return UITableViewCell() }
        let dateFor = DateFormatter()
        //Tarkistetaan onko päivämäärällä sama aikavyöhyke kuin systeemillä. Näytetään aikavyöhyke ainoastaan jos se on eri.
        dateFor.dateFormat =  "Z"
        if dateFor.string(from: ankat[indexPath.row].dateTime) != dateFor.string(from: Date()){
            dateFor.dateFormat = "dd.MM.yyyy HH:mm ZZZZZZ"
        }
        else {
            dateFor.dateFormat = "dd.MM.yyyy HH:mm"
        }
        
        //Asetetaan labelien tekstit
        cell.desc_label.text = "Description:\n" + ankat[indexPath.row].description
        cell.datetime_label.text = "Time: " +  dateFor.string(from: ankat[indexPath.row].dateTime)
        cell.count_label.text = "Count: " + String(ankat[indexPath.row].count)
        cell.species_label.text = "Species: " +  ankat[indexPath.row].species.capitalized
        
        return cell
    }
    
    
    }
    

