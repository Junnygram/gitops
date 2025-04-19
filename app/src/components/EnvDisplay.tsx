// components/EnvDisplay.tsx
type EnvDisplayProps = {
  value?: string;
};

const EnvDisplay = ({ value }: EnvDisplayProps) => {
  return (
    <div className="p-4 bg-gray-100 rounded">
      <p className="text-lg font-mono">Env: {value}</p>
    </div>
  );
};

export default EnvDisplay;
