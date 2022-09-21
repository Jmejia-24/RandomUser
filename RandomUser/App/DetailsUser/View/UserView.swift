//
//  UserView.swift
//  RandomUser
//
//  Created by Byron Mejia on 9/15/22.
//

import UIKit
import SDWebImage
import MapKit

final class UserView: UIView {
    private var viewModel: UserDetailViewModelProtocol
    
    init(viewModel: UserDetailViewModelProtocol) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        buildView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private lazy var containerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "PlaceHolderImage")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var nameStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fillProportionally
        return stackView
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        return label
    }()
    
    private lazy var genderLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        return label
    }()
    
    private lazy var locationMapView: MKMapView = {
        var mapview = MKMapView()
        mapview.translatesAutoresizingMaskIntoConstraints = false
        
        let homeLoc = MKPointAnnotation()
        let lat = Double(viewModel.userDetail.location?.coordinates?.latitude ?? "") ?? 0.0
        let lon = Double(viewModel.userDetail.location?.coordinates?.longitude ?? "") ?? 0.0
        
        homeLoc.coordinate = CLLocationCoordinate2DMake(lat, lon)
        homeLoc.title = "Home"
        mapview.setCenter(homeLoc.coordinate, animated: true)
        mapview.showAnnotations([homeLoc], animated: true)
        return mapview
    }()
    
    private lazy var userNameDescription: UserDescriptionView = {
        return UserDescriptionView(title: "User Name")
    }()
    
    private lazy var emailDescription: UserDescriptionView = {
        return UserDescriptionView(title: "Email")
    }()
    
    private lazy var ageDescription: UserDescriptionView = {
        return UserDescriptionView(title: "Age")
    }()
    
    private lazy var nationalityDescription: UserDescriptionView = {
        return UserDescriptionView(title: "Nationality")
    }()
    
    private lazy var phoneDescription: UserDescriptionView = {
        return UserDescriptionView(title: "Phone")
    }()
    
    private func configure() {
        let user = viewModel.userDetail
        let fullName = "\(user.name?.title ?? "") \(user.name?.first ?? "") \(user.name?.last ?? "")"
        let userName = user.login?.username ?? ""
        let email = user.email ?? ""
        let age = String(user.dob?.age ?? 0)
        let nationality = user.location?.country ?? ""
        let phone = user.phone ?? ""
        
        genderLabel.text = user.gender?.capitalized ?? ""
        nameLabel.text = fullName
        userNameDescription.setText(userName)
        emailDescription.setText(email)
        ageDescription.setText(age)
        nationalityDescription.setText(nationality)
        phoneDescription.setText(phone)
        
        if let url = URL(string: user.picture?.large ?? "") {
            imageView.sd_setImage(with: url,
                                  placeholderImage: #imageLiteral(resourceName: "PlaceHolderImage"),
                                  options: .retryFailed,
                                  context: nil)
        }
    }
}

extension UserView: ViewCodeProtocol {
    
    func setupHierarchy() {
        nameStackView.addArrangedSubview(genderLabel)
        nameStackView.addArrangedSubview(nameLabel)
        
        containerStackView.addArrangedSubview(imageView)
        containerStackView.addSpacing(18)
        containerStackView.addArrangedSubview(nameStackView)
        containerStackView.addSpacing(18)
        containerStackView.addArrangedSubview(userNameDescription)
        containerStackView.addSpacing(9)
        containerStackView.addArrangedSubview(emailDescription)
        containerStackView.addSpacing(18)
        containerStackView.addArrangedSubview(ageDescription)
        containerStackView.addSpacing(18)
        containerStackView.addArrangedSubview(phoneDescription)
        containerStackView.addSpacing(18)
        containerStackView.addArrangedSubview(nationalityDescription)
        containerStackView.addSpacing(18)
        containerStackView.addArrangedSubview(locationMapView)
        
        scrollView.addSubview(containerStackView)
        addSubview(scrollView)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            scrollView.widthAnchor.constraint(equalTo: widthAnchor)
        ])
        
        NSLayoutConstraint.activate([
            containerStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -30),
            containerStackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 10),
            containerStackView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 30),
            containerStackView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -30)
        ])
        
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalTo: containerStackView.widthAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 250)
        ])
        
        NSLayoutConstraint.activate([
            locationMapView.widthAnchor.constraint(equalTo: containerStackView.widthAnchor),
            locationMapView.heightAnchor.constraint(equalToConstant: 250)
        ])
    }
    
    func additionalSetup() {
        backgroundColor = .white
        configure()
    }
}
