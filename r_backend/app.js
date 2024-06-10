const express = require('express');
const { exec } = require('child_process');
const path = require('path');
const cors = require('cors');
const fs = require('fs');
const app = express();
const port = 3000;


app.use(cors());

app.use(express.json());

app.get('/', (req, res) => {
  res.json({ message: 'This endpoint is working.' });
});

// Ensure output directory exists
const outputDir = path.join(__dirname, 'output');
if (!fs.existsSync(outputDir)) {
  fs.mkdirSync(outputDir);
}

// Endpoint to generate graph
app.get('/generate-graph', (req, res) => {
  // Path to the R script
  const scriptPath = path.join(__dirname, 'generate_graph.R');
  const imagePath = path.join(__dirname, 'output', 'student_info.png');

  // Execute the R script
  exec(`Rscript ${scriptPath}`, (error, stdout, stderr) => {
    if (error) {
      console.error(`Error executing R script: ${error.message}`);
      return res.status(500).send('Error generating graph');
    }
    if (stderr) {
      console.error(`R script stderr: ${stderr}`);
    }

    // Send back the full URL of the generated image
    const imageUrl = `${req.protocol}://${req.get('host')}/output/student_info.png`;
    res.send({ imageUrl });
  });
});

// Serve static files from the 'output' directory
app.use('/output', express.static(path.join(__dirname, 'output')));

app.listen(port, () => {
  console.log(`Server is running on http://localhost:${port}`);
});
