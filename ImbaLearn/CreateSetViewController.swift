//
//  CreateSetViewController.swift
//  ImbaLearn
//
//  Created by Leyla Aliyeva on 18.11.25.
//

import UIKit

class CreateSetViewController: BaseViewController {
    
    // MARK: - UI Elements
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var headerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .color
        return view
    }()
    
    private lazy var headerTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Create New Set"
        label.textColor = .black
    
        label.alpha = 0.6
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Title"
        label.textColor = .text
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var titleTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter set title"
        textField.borderStyle = .none
        textField.backgroundColor = .white
        textField.layer.cornerRadius = 12
        textField.layer.masksToBounds = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: textField.frame.height))
        textField.leftView = paddingView
        textField.leftViewMode = .always
        
        return textField
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Description"
        label.textColor = .text
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var descriptionTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter description (optional)"
        textField.borderStyle = .none
        textField.backgroundColor = .white
        textField.layer.cornerRadius = 12
        textField.layer.masksToBounds = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: textField.frame.height))
        textField.leftView = paddingView
        textField.leftViewMode = .always
        
        return textField
    }()
    
    private lazy var termsLabel: UILabel = {
        let label = UILabel()
        label.text = "Terms"
        label.textColor = .text
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(TermCell.self, forCellReuseIdentifier: "TermCell")
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.isScrollEnabled = false
        tableView.rowHeight = 120
        return tableView
    }()
    
    private lazy var addTermButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("+ Add another term", for: .normal)
        button.setTitleColor(.pinkButton, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(addTermTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Save to Library", for: .normal)
        button.backgroundColor = .pinkButton
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 16
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(saveTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Properties
    private var terms: [Term] = [
        Term(term: "", definition: ""),
        Term(term: "", definition: "")
    ]
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
    //    setupGradientHeader()
        setupTableView()
        setupTextFields()
    }
    
    private func setupUI() {
        view.backgroundColor = .background
        title = "Create New Set"
        
        // Add header view directly to main view
        view.addSubview(headerView)
        headerView.addSubview(headerTitleLabel)
        
        // Add scroll view and content view below header
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        // Add all form elements to contentView
        contentView.addSubviews(titleLabel, titleTextField, descriptionLabel, descriptionTextField, termsLabel, tableView, addTermButton, saveButton)
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func setupTextFields() {
        // Set up text field delegates
        let textFields = [titleTextField, descriptionTextField]
        textFields.forEach { textField in
            textField.delegate = self
        }
        
        // Enable keyboard avoidance
        setupKeyboardAvoidance(with: scrollView)
    }
    
//    private func setupGradientHeader() {
//        // Create gradient layer
//        let gradientLayer = CAGradientLayer()
//        gradientLayer.colors = [
//            UIColor.pinkButton.cgColor,
//            UIColor.greenButton.cgColor
//        ]
//        gradientLayer.locations = [0.0, 1.0]
//        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
//        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
//        
//        // Set the frame after layout
//        DispatchQueue.main.async {
//            gradientLayer.frame = self.headerView.bounds
//        }
//        
//        headerView.layer.insertSublayer(gradientLayer, at: 0)
//    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // Update gradient layer frame when view layout changes
        if let gradientLayer = headerView.layer.sublayers?.first as? CAGradientLayer {
            gradientLayer.frame = headerView.bounds
        }
        
        // Update table view height based on content
        updateTableViewHeight()
    }
    
    private func setupConstraints() {
        let padding: CGFloat = 20
        let fieldHeight: CGFloat = 60
        let labelHeight: CGFloat = 20
        let headerHeight: CGFloat = 140
        _ = view.safeAreaInsets.bottom > 0 ? view.safeAreaInsets.bottom : 20

        
        NSLayoutConstraint.activate([
            // Header View - Fixed at top
            headerView.topAnchor.constraint(equalTo: view.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: headerHeight),
            
            // Header Title Label - centered in header
            headerTitleLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor, constant: 20),
            headerTitleLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: padding),
            headerTitleLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -padding),
            
            // Scroll View - Below header
            scrollView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            // Content View
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            // Title Label
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 30),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            titleLabel.heightAnchor.constraint(equalToConstant: labelHeight),
            
            // Title Text Field
            titleTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            titleTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            titleTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            titleTextField.heightAnchor.constraint(equalToConstant: fieldHeight),
            
            // Description Label
            descriptionLabel.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 20),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            descriptionLabel.heightAnchor.constraint(equalToConstant: labelHeight),
            
            // Description Text Field
            descriptionTextField.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 8),
            descriptionTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            descriptionTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            descriptionTextField.heightAnchor.constraint(equalToConstant: fieldHeight),
            
            // Terms Label
            termsLabel.topAnchor.constraint(equalTo: descriptionTextField.bottomAnchor, constant: 30),
            termsLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            termsLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            termsLabel.heightAnchor.constraint(equalToConstant: labelHeight),
            
            // Table View
            tableView.topAnchor.constraint(equalTo: termsLabel.bottomAnchor, constant: 12),
            tableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            tableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            tableView.heightAnchor.constraint(equalToConstant: CGFloat(terms.count) * 120),
            
            // Add Term Button
            addTermButton.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 20),
            addTermButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            addTermButton.heightAnchor.constraint(equalToConstant: 30),
            
            // Save Button
            saveButton.topAnchor.constraint(equalTo: addTermButton.bottomAnchor, constant: 40),
            saveButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            saveButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            saveButton.heightAnchor.constraint(equalToConstant: fieldHeight),
            saveButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -40)
        ])
    }
    
    // MARK: - Actions
    @objc private func addTermTapped() {
        terms.append(Term(term: "", definition: ""))
        updateTableViewHeight()
        tableView.reloadData()
        
        // Scroll to the new term
        let lastIndex = IndexPath(row: terms.count - 1, section: 0)
        tableView.scrollToRow(at: lastIndex, at: .bottom, animated: true)
    }
    
    @objc private func saveTapped() {
        // TODO: Implement save logic
        print("Saving set: \(titleTextField.text ?? "")")
        print("Terms: \(terms)")
        
        // Validate required fields
        guard let title = titleTextField.text, !title.isEmpty else {
            showAlert(message: "Please enter a title for your set")
            return
        }
        
        // Validate that at least one term has both fields filled
        let validTerms = terms.filter { !$0.term.isEmpty && !$0.definition.isEmpty }
        guard !validTerms.isEmpty else {
            showAlert(message: "Please add at least one term with both term and definition")
            return
        }
        
        // Save logic here
        showAlert(message: "Set saved successfully!")
    }
    
    @objc private func deleteTermTapped(_ sender: UIButton) {
        let point = sender.convert(CGPoint.zero, to: tableView)
        if let indexPath = tableView.indexPathForRow(at: point) {
            terms.remove(at: indexPath.row)
            updateTableViewHeight()
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    // MARK: - Helper Methods
    private func updateTableViewHeight() {
        let newHeight = CGFloat(terms.count) * 120
        tableView.constraints.forEach { constraint in
            if constraint.firstAttribute == .height {
                constraint.constant = newHeight
            }
        }
        view.layoutIfNeeded()
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - UITableViewDataSource & UITableViewDelegate
extension CreateSetViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return terms.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TermCell", for: indexPath) as! TermCell
        let term = terms[indexPath.row]
        cell.configure(with: term, tag: indexPath.row)
        cell.deleteButton.tag = indexPath.row
        cell.deleteButton.addTarget(self, action: #selector(deleteTermTapped), for: .touchUpInside)
        
        // Set up text field callbacks
        cell.termTextChanged = { [weak self] text in
            self?.terms[indexPath.row].term = text
        }
        
        cell.definitionTextChanged = { [weak self] text in
            self?.terms[indexPath.row].definition = text
        }
        
        return cell
    }
}

// MARK: - Term Model
struct Term {
    var term: String
    var definition: String
}

