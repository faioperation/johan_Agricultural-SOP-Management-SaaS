import { useLocation } from "react-router-dom";

const Breadcrumb = () => {
  const { pathname } = useLocation();

  const pathParts = pathname.split("/").filter(Boolean);

  //     remove role + ids
  const cleanedParts = pathParts.filter(
    (part) =>
      !["admin", "owner"].includes(part.toLowerCase()) &&
      !/^\d+$/.test(part)
  );

  //   Special route handling
  let titleParts = [];

  //   SOP Edit page
  if (
    cleanedParts.includes("edit") &&
    cleanedParts.includes("sop")
  ) {
    titleParts = ["Edit", "SOP"];
  }
  //   SOP Create page
  else if (
    cleanedParts.includes("create") &&
    cleanedParts.includes("sop")
  ) {
    titleParts = ["Create", "SOP"];
  }
  //   Default: last two segments
  else {
    titleParts =
      cleanedParts.length >= 2
        ? cleanedParts.slice(-2)
        : cleanedParts;
  }

  const formatWord = (word) => {
    if (word.toLowerCase() === "sop") return "SOP";

    return word
      .replaceAll("-", " ")
      .replace(/\b\w/g, (c) => c.toUpperCase());
  };

  const title = titleParts.map(formatWord).join(" ");

  return (
    <div className="flex items-center">
      <h3 className="text-[#0A0A0A] text-3xl whitespace-nowrap">
        {title}
      </h3>
    </div>
  );
};

export default Breadcrumb;
