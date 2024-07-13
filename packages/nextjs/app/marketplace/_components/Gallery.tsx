"use client";

import ProductCard from "./ProductCard";
import type { NextPage } from "next";

const Gallery: NextPage = () => {
  const products = [
    { src: "https://via.placeholder.com/150", title: "Acme Slip-On Shoes", price: "$45.00 USD" },
    { src: "https://via.placeholder.com/150", title: "Acme Circles T-Shirt", price: "$20.00 USD" },
    { src: "https://via.placeholder.com/150", title: "Acme Drawstring Bag", price: "$12.00 USD" },
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
