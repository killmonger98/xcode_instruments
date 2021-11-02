//
//  TimelineScreenViewController.swift
//  Qsafe
//
//  Created by Abhiram on 09/02/21.
//

import UIKit

class TimelineScreenViewController: UIViewController {

    enum Identifiers: String {

        case calendarDayCell = "CalendarDayCell"
        case visitedShopCell = "VisitedShopCell"

    }

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!

    var today = Date()

    let weekdays: [Int: String] = [1: "Sun", 2: "Mon", 3: "Tue", 4: "Wed",
                                   5: "Thu", 6: "Fri", 7: "Sat"]

    // dummy data for testing 
    var days: [Day] = []

    override func viewDidLoad() {

        super.viewDidLoad()
        createDays()
        tableView.register(VisitedShopCell.nib(), forCellReuseIdentifier: Identifiers.visitedShopCell.rawValue)

    }

    override func viewDidAppear(_ animated: Bool) {

        let item = collectionView(collectionView, numberOfItemsInSection: 0) - 1
        let lastItemIndex = IndexPath(item: item, section: 0)
        collectionView.scrollToItem(at: lastItemIndex, at: .right, animated: true)
        let lastCell = collectionView(collectionView, cellForItemAt: lastItemIndex)
        lastCell.isSelected = true

    }

    // MARK: 28 DAYS CREATION
    func createDays() {

        let num = numberOfDaysInCalendar
        var firstDay = today.changeDaysBy(days: -(num-1))
        for count in 1...num {
            let components = Calendar.current.dateComponents([.month, .day, .weekday], from: firstDay)
            let day = Day(date: firstDay, dayOfMonth: components.day ?? 0,
                          dayOfWeek: String(weekdays[components.weekday ?? 0] ?? "NIL"))
            days.append(day)
            firstDay = today.changeDaysBy(days: (-(num-1) + count))
        }

    }

    @IBAction func backButton(_ sender: Any) {

        navigationController?.popViewController(animated: true)

    }

    func logoutUser() {

        let isLoggedIn = false
        UserDefaults.standard.set(isLoggedIn, forKey: "isLoggedIn")

    }

}

// MARK: - DAYS - COLLECTION VIEW DELEGATE
extension TimelineScreenViewController: UICollectionViewDelegate, UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        // API call - Result : Shops visited by user on that day

    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return days.count

    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Identifiers.calendarDayCell.rawValue,
                                                         for: indexPath)
        if let calendarCell = cell as? CalendarDayCell {

            calendarCell.cellContentView.layer.borderColor = primaryColor.cgColor
            calendarCell.setAttributes(days[indexPath.row])

            return calendarCell

        }

        return cell
    }

}

// MARK: - SHOPS - TABLE VIEW DELEGATE
extension TimelineScreenViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return 12

    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let emptyCell = UITableViewCell()

        if let cell = tableView.dequeueReusableCell(withIdentifier: Identifiers.visitedShopCell.rawValue,
                                                    for: indexPath) as? VisitedShopCell {

            cell.cellContentView.layer.borderColor = primaryColor.cgColor

            return cell

        }

        return emptyCell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        // temporary log out 
        logoutUser()

    }

}
