//
//  ViewController.swift
//  Stretchable picture1
//
//  Created by aeroclub on 21.11.2024.
//

import UIKit

class ViewController: UIViewController, UIScrollViewDelegate {
    
    let imageView = UIImageView()
    let scrollView = UIScrollView()
    let contentView = UIView()
    var imageHeightConstraint: NSLayoutConstraint!
    
    // Начальная высота изображения
    let initialImageHeight: CGFloat = 270
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupImageView()
        setupScrollView()
        setupContent()
    }
    
    func setupImageView() {
        imageView.image = UIImage(named: "myImage2")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        view.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        // Устанавливаем начальные ограничения для imageView и сохраняем ограничение высоты
        imageHeightConstraint = imageView.heightAnchor.constraint(equalToConstant: initialImageHeight)
        imageHeightConstraint.isActive = true
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    func setupScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        scrollView.delegate = self
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: imageView.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        scrollView.contentInsetAdjustmentBehavior = .never
    }
    
    func setupContent() {
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
        
        // Установка высоты контента
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentView.heightAnchor.constraint(equalToConstant: 1000) // Высота контента
        ])
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        
        // Рассчитываем новую высоту для imageView
        let newHeight: CGFloat
        if offsetY < 0 {
            // Растягиваем изображение при прокрутке вниз
            newHeight = initialImageHeight - offsetY // Увеличиваем высоту на величину смещения
            imageView.frame.origin.y = 0
        } else {
            // Если мы прокручиваем вверх, устанавливаем максимальную высоту
            newHeight = max(initialImageHeight, initialImageHeight - offsetY)
            imageView.frame.origin.y = -offsetY // Двигаем изображение вверх вместе с прокруткой
        }
        
        // Устанавливаем новую высоту imageView
        imageView.frame.size.height = newHeight
        
        // Обновляем contentInset ScrollView
        scrollView.contentInset = UIEdgeInsets(top: newHeight - initialImageHeight, left: 0, bottom: 0, right: 0)
        
        // Обновляем contentSize ScrollView
        let totalHeight = contentView.frame.height + (newHeight - initialImageHeight)
        scrollView.contentSize = CGSize(width: scrollView.frame.width, height: totalHeight)
        
        // Если прокручивается обратно и достигаем позиции 0, сбрасываем изображение
        if offsetY <= 0 {
            resetImageView()
        }
    }
    
    func resetImageView() {
        UIView.animate(withDuration: 0.7) {
            self.imageHeightConstraint.constant = self.initialImageHeight
            self.imageView.frame.origin.y = 0 // Возвращаем изображение на место
            self.view.layoutIfNeeded() // Обновляем интерфейс
            // Обновляем scrollView для корректной высоты
            self.scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            self.scrollView.contentSize.height = self.contentView.frame.height
        }
    }
}

