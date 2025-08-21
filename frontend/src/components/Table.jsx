import React from "react";

export default function Table({ TableHeads, TableRows,headClass,tableClass }) {
  return (
    <table className={`w-full  border-collapse bg-white overflow-hidden ${tableClass}`}>
      {/* ==== TABLE HEADER ==== */}
      <thead>
        <tr className="">
          {TableHeads.map((head, idx) => (
            <th
              key={idx}
              className={`text-center border-b  border-[#000000]/10 bg-[#E5E7EB]   font-inter text-[#4A5565]  py-[22px]   
                ${idx === 0 ? "" : ""}
                ${idx === TableHeads.length - 1 ? "" : ""} ${headClass}`}
              style={{ width: head.width }}
            >
              {head.Title}
            </th>
          ))}
        </tr>
      </thead>

      {/* ==== TABLE BODY ==== */}
      <tbody className="">
        {TableRows.map((row, rowIdx) => (
          <tr key={rowIdx}>
            {TableHeads.map((head, headIdx) => (
              <td
                key={headIdx}
                className="border-b  border-[#000000]/10  py-[22px] text-center px-3 font-inter  text-[#0A0A0A] "
              >
                {/* If render function exists, use it — otherwise show plain data */}
                {head.render ? head.render(row, rowIdx) : row[head.key]}
              </td>
            ))}
          </tr>
        ))}
      </tbody>
    </table>
  );

  //  <Table TableHeads={TableHeads} TableRows={filteredData} />
}