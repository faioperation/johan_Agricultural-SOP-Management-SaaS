import React, { useState } from "react";
import RichTextEditor from "./RichTextEditor";

const CreateDigitalModule = ({ value, onChange, onImageUpload }) => {
  return (
    <div>
      <RichTextEditor 
        value={value} 
        onChange={onChange} 
        onImageUpload={onImageUpload}
      />
    </div>
  );
};

export default CreateDigitalModule;