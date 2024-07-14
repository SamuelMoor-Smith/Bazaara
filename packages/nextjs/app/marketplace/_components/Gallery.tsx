"use client";

import ProductCard from "./ProductCard";
import type { NextPage } from "next";

const Gallery: NextPage = () => {
  const products = [
    // { src: "car.png", title: "Toy Car", price: "$45.00 USD" },
    // { src: "xylo.png", title: "Xylophone", price: "$20.00 USD" },
    { src: "vase.png", title: "NFT Market", orderType: 1 },
    { src: "fruit.png", title: "Beneficiary Market", orderType: 2 },
    // Add more products as needed
  ];

  return (
    <div className="flex-1 p-4">
      <div className="grid grid-cols-4 gap-4">
        {products.map((product, index) => (
          <ProductCard key={index} product={product} />
        ))}
      </div>
    </div>
  );
};

export default Gallery;
