//
//  ForecastsController.swift
//  RPWeather
//
//  Created by Alexander Senin on 06.10.2021.
//

import UIKit

class ForecastsController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
    }

    var weatherDailyData: WeatherDailyData?
    
    override func viewWillAppear(_ animated: Bool) {
        LocationManager.sharedInstance.getCurrentLocation { lat, lon in
            Model().refreshDailyWeatherData(lat: lat, lon: lon) { weatherDailyData, error in
                if let error = error {
                    print(error)
                    return
                }
                self.weatherDailyData = weatherDailyData
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if weatherDailyData == nil {
            return 0
        }
        
        if section == 0 {
            return 1
        }
        
        if section == 1 {
            return weatherDailyData!.daysTemperature.count
        }
        
        return 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
            cell.textLabel?.text = weatherDailyData?.city
            cell.detailTextLabel?.text = ""
            return cell
        }

        if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
            cell.textLabel?.text = weatherDailyData?.daysTemperature[indexPath.row].dayString
            cell.detailTextLabel?.text = weatherDailyData?.daysTemperature[indexPath.row].degreesCelsiy
            return cell
        }

        return UITableViewCell()
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
