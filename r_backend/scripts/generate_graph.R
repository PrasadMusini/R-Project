# Load required libraries
library(ggplot2)

# Example student data
students <- data.frame(
    Name = c("Alice", "Bob", "Charlie"),
    Age = c(20, 22, 21),
    Score = c(85, 90, 78)
)

# Generate the plot
png("output.png")
ggplot(students, aes(x=Name, y=Score)) + geom_bar(stat="identity") + theme_minimal()
dev.off()

# Save the path to the generated image
cat("output.png")
