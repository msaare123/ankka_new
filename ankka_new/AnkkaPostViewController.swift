//
//  ViewController2.swift
//  ankka_new
//  Ankkatietojen lähettämiseen palvelimelle tarkoitettu näkymä ja sen toiminnot
//  Created by Matti Saarela on 25/01/2018.
//  Copyright © 2018 Matti Saarela. All rights reserved.
//

import UIKit

class AnkkaPostViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
 
    
    
    final let urlspecies = URL(string: serverAddress + "/species") //URL for species json
    final let urlPost = URL(string: serverAddress + "/sightings")
    var species: [Species] = [] //Lajitaulukko
    var id = 0
    var count = 0

    
    
    @IBOutlet weak var description_field: UITextField!
    @IBOutlet weak var species_picker: UIPickerView!
    @IBOutlet weak var count_field: UITextField!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        species_picker.delegate = self
        species_picker.dataSource = self
        description_field.delegate = self


        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        downloadSpeciesJSON()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
   

    
    func downloadSpeciesJSON(){
        //Lataa palvelimelta listan ankkalajeista
        guard let downloadURL = urlspecies else{return}
        URLSession.shared.dataTask(with: downloadURL) { (data, urlResponse, error) in
            guard let data = data, error == nil, urlResponse != nil else {
                let alert = UIAlertController(title: "Download Error", message: "Error occured while trying to download species data from the server", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                    NSLog("Species Download Error Occured!" + error.debugDescription)
                }))
                self.present(alert, animated: true, completion: nil)
                return
            }
            do {
                let decoder = JSONDecoder();
                let downloaded_species = try decoder.decode([Species].self, from: data)
                self.species = downloaded_species
                DispatchQueue.main.async {
                    self.species_picker.reloadAllComponents()
                }
            }
            catch{
                let alert = UIAlertController(title: "Decoding Error", message: "Error occured while trying to decode downloaded species data", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                    NSLog("Species Decoding error occured!" + error.localizedDescription)
                }))
                self.present(alert, animated: true, completion: nil)
                return
            }
        
        }.resume()
    }
    
    func htmlPost(url: URL, sighting: Ankka) {
        var request = URLRequest(url: url)
        var postString: Data
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        let dateFor = DateFormatter()
        dateFor.dateFormat = "yyyy-MM-dd'T'HH:mm:ssXXXXX"
        
        do {
            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .formatted(dateFor)
            let encodedString = try encoder.encode(sighting)
            postString = encodedString
        }
        catch{
            let alert = UIAlertController(title: "Error", message: "Error occured while encoding data", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                NSLog("JSON Encoding Error occured!" + error.localizedDescription)
            }))
            self.present(alert, animated: true, completion: nil)
            return
        }
        request.httpBody = postString
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let _ = data, error == nil else {
                let alert = UIAlertController(title: "Error", message: "Error occured while posting data", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                    NSLog("HTTP Post Error Occured!" + error.debugDescription)
                }))
                self.present(alert, animated: true, completion: nil)
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                print(response.debugDescription)
            }
        }
        task.resume()
    }
    
    //PickerViewin sarakkeet
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return species.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return species[row].name.capitalized
    }
    
    
    @IBAction func AddSightningButtonPressed(_ sender: UIButton) {
        //Tarksitetaan käyttäjän syöte ja lähetetään palvelimelle
        let inputTime:Date = datePicker.date
        var inputCount:Int? = nil
        var inputSpecies:String? = nil
        //Jos lukumääräkenttä on tyhjä niin muunnosta integeriksi ei tehdä
        if count_field.text!.decimalsOnly() != "" {
            inputCount = Int(count_field.text!.decimalsOnly())!
        }
        if species.count > 0 {
            inputSpecies = species[species_picker.selectedRow(inComponent: 0)].name
        }
        let inputDesc:String? = description_field.text
        //Virheilmoitusikkuna virheellistä syötettä varten
        var alertText = "Unknown Error."
        var alertTitle = "Error!"
        
        //Ennen palvelimelle lähetystä täytyy todentaa että kaikki tarvittava data on muuttujissa saatavilla
        if inputCount != nil && inputCount! > 0 && inputDesc != nil && inputDesc != "" && urlPost != nil && inputSpecies != nil {
            let inputAnkka = Ankka(id: 0, species: inputSpecies!, description: inputDesc!, dateTime: inputTime, count: inputCount!)
            htmlPost(url: urlPost!, sighting: inputAnkka)
            let SuccessfulAlert = UIAlertController(title: "Successful", message: "Duckdata uploaded successfully", preferredStyle: .alert)
            SuccessfulAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                NSLog("Duckdata upload successful!")
            }))
            self.present(SuccessfulAlert, animated: true, completion: nil)
            return
        }
        // Jos joku tarvittava data uupuu. Annetaan käyttäjälle siitä virhe
        else if inputCount == nil {
            alertTitle = "KVAAK!"
            alertText = "Invalid count"
        }
        else if inputCount! < 1 {
            alertTitle = "KVAAK!"
            alertText = "Count has to be bigger than 0"
        }
        else if inputDesc == "" || inputDesc == nil {
            alertTitle = "KVAAK!"
            alertText = "Invalid description"
        }
        else if inputSpecies == nil {
            alertTitle = "KVAAK!"
            alertText = "Invalid Species"
        }
        let alert = UIAlertController(title: alertTitle, message: alertText, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            NSLog("User Input Error Occured!")
        }))
        self.present(alert, animated: true, completion: nil)
    }
}

extension AnkkaPostViewController: UITextFieldDelegate {
    //Done button dismisses the keyboard in description field
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.description_field.resignFirstResponder()
        return true
    }
}

extension String {
    //Suodattaa stringistä kaikki muut paitsi numerot pois
    func decimalsOnly() -> String {
        return self.components(separatedBy: CharacterSet.decimalDigits.inverted).joined(separator: "")
    }
}
