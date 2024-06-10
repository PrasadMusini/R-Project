# Load necessary libraries
library(ggplot2)

# Create output directory if it doesn't exist
dir.create("output", showWarnings = FALSE)

# Sample data (replace this with actual student data)
student_data <- data.frame(
  Name = c('Jessy', 'Xyaa', 'Raju', 'Teddy'),
  Score = c(85, 92, 78, 88)
)

# Create a plot
plot <- ggplot(student_data, aes(x = Name, y = Score)) +
  geom_bar(stat = 'identity') +
  theme_minimal() +
  ggtitle('Student Scores')

# Save the plot as an image
ggsave('output/student_info.png', plot)
