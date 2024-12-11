int[][] data = {
  {1, 3, 100}, {2, 3, 95}, {3, 2, 85}, {4, 2, 90}, {1, 1, 70}, // Week 1
  {2, 3, 100}, {3, 3, 90}, {4, 3, 100}, {1, 2, 60}, {2, 2, 85}, // Week 2
  {3, 1, 75}, {4, 3, 95}, {1, 3, 100}, {2, 3, 90}, {3, 2, 80}, // Week 3
  {4, 3, 100}, {1, 1, 50}, {2, 2, 80}, {3, 2, 70}, {4, 3, 90}, // Week 4
  {1, 3, 100}, {2, 3, 95}, {3, 2, 85}, {4, 2, 80}, {1, 1, 60}, // Week 5
  {2, 3, 90}, {3, 2, 70}, {4, 3, 95}, {1, 3, 100}, {2, 2, 85}  // Week 6
};

String[] workoutTypes = {"Leg", "Chest+Triceps", "Back+Biceps", "Arms"};
String[] colors = {"Not Motivated", "Neutral", "Motivated"};
int[][] motivationColors = {{255, 0, 0}, {255, 255, 0}, {0, 255, 0}}; // RGB Colors

int gridSize = 6; // Rows and columns of the visual grid
int shapeSize = 50; // Size of each shape
boolean showPopup = false;
int popupX, popupY, selectedIndex;

void setup() {
  size(950, 950); // Larger canvas width to show all shapes
  textFont(createFont("Arial", 14));
  noLoop();
}

void draw() {
  background(240); // Light white background for better contrast
  drawBackgroundDesign();
  drawLegends();

  for (int i = 0; i < data.length; i++) {
    int col = i % gridSize;
    int row = i / gridSize;
    int x = col * (shapeSize + 100) + 100; // Adjust x-position with padding
    int y = row * (shapeSize + 100) + 200; // Move shapes down by 50 units and shift left

    // Set color based on motivation level
    int[] rgb = motivationColors[data[i][1] - 1];
    fill(rgb[0], rgb[1], rgb[2]);
    drawShape(data[i][0], x, y);

    // Check if a popup should be shown for this shape
    if (showPopup && i == selectedIndex) {
      drawPopup(x, y, i);
    }
  }
}

void drawBackgroundDesign() {
  stroke(0, 0, 0, 50); // Semi-transparent black for grid lines
  for (int i = 0; i < width; i += 40) {
    line(i, 0, width, height - i); // Diagonal left-to-right
    line(0, i, width - i, height); // Diagonal right-to-left
  }

  // Draw small dots in pink, purple, and light blue
  for (int y = 0; y < height; y += 20) {
    for (int x = 0; x < width; x += 20) {
      int randomColor = int(random(3));
      if (randomColor == 0) {
        fill(255, 182, 193); // Pink
      } else if (randomColor == 1) {
        fill(128, 0, 128);   // Purple
      } else {
        fill(173, 216, 230); // Light Blue
      }
      ellipse(x, y, 5, 5); // Draw small dot
    }
  }
}

// Draws different shapes based on the workout type
void drawShape(int type, int x, int y) {
  noStroke();
  int halfSize = shapeSize / 2;
  
  switch (type) {
    case 1: // Leg (Triangle)
      triangle(x, y - halfSize, x - halfSize, y + halfSize, x + halfSize, y + halfSize);
      break;
    case 2: // Chest+Triceps (Circle)
      ellipse(x, y, shapeSize, shapeSize);
      break;
    case 3: // Back+Biceps (Square)
      rect(x - halfSize, y - halfSize, shapeSize, shapeSize);
      break;
    case 4: // Arms (Diamond)
      pushMatrix();
      translate(x, y);
      rotate(PI / 4);
      rect(-halfSize, -halfSize, shapeSize, shapeSize);
      popMatrix();
      break;
  }
}

void mousePressed() {
  // Detect if mouse is clicked on any shape
  for (int i = 0; i < data.length; i++) {
    int col = i % gridSize;
    int row = i / gridSize;
    int x = col * (shapeSize + 100) + 150; // Adjust x-position for left margin
    int y = row * (shapeSize + 100) + 200; // Adjust y-position for top margin

    // Check distance from mouse to shape
    if (dist(mouseX, mouseY, x, y) < shapeSize) {
      showPopup = true;
      popupX = mouseX;
      popupY = mouseY - 100; // Position popup above the shape
      selectedIndex = i;
      redraw();
      return;
    }
  }
  showPopup = false;
  redraw();
}

// Draws popup with detailed workout information
void drawPopup(int x, int y, int index) {
  fill(50); // Popup background color
  stroke(200); // Popup border color
  rect(popupX, popupY, 200, 100); // Popup dimensions

  fill(255); // Text color
  text("Workout: " + workoutTypes[data[index][0] - 1], popupX + 10, popupY + 20);
  text("Motivation: " + colors[data[index][1] - 1], popupX + 10, popupY + 40);
  text("Completion: " + data[index][2] + "%", popupX + 10, popupY + 60);
}

// Draws legends for motivation levels only
void drawLegends() {
  // Top-left legend for motivation levels
  fill(220);
  rect(20, 20, 200, 100); // Top-left legend box
  fill(0);
  textAlign(LEFT, TOP);
  text("Motivation Levels:", 30, 30);
  for (int i = 0; i < colors.length; i++) {
    int x = 30;
    int y = 50 + i * 20;

    fill(motivationColors[i][0], motivationColors[i][1], motivationColors[i][2]);
    rect(x, y, 15, 15); // Color box
    fill(0);
    text(colors[i], x + 20, y); // Aligned text
  }
}
