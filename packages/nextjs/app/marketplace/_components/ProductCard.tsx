"use client";

const ProductCard = ({ product }: { product: { src: string; title: string; price: string } }) => {
  return (
    <div className="card bg-base-300 rounded-3xl px-6 lg:px-8 py-4 shadow-lg shadow-base-300">
      <figure>
        <img src="/logo-background.png" alt={product.title} className="mb-2 mt-6" />
      </figure>
      <div className="card-body">
        <h2 className="font-bold text-lg mb-0 break-all">{product.title}</h2>
        <p className="font-medium text-sm my-0">{product.price}</p>
      </div>
    </div>
  );
};

export default ProductCard;
