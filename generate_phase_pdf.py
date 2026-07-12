from pathlib import Path
from reportlab.lib.pagesizes import A4
from reportlab.lib.styles import getSampleStyleSheet, ParagraphStyle
from reportlab.platypus import SimpleDocTemplate, Paragraph, Spacer, PageBreak
from reportlab.lib import colors
from reportlab.lib.units import inch

root = Path(r"c:/Users/DELL/OneDrive/Documents/databricks-training")
out_pdf = root / "phase_outputs_report.pdf"

for rel in [
    "Phase 1/outputs/sql_output_table.md",
    "Phase 1/outputs/pyspark_output_table.md",
    "Phase 2/outputs/sql_output_table.md",
    "Phase 2/outputs/pyspark_output_table.md",
    "Phase 3/outputs/sql_output_table.md",
    "Phase 3/outputs/pyspark_output_table.md",
    "Phase 4a/outputs/sql_output_table.md",
    "Phase 4a/outputs/pyspark_output_table.md",
    "Phase 4b/outputs/sql_output_table.md",
    "Phase 4b/outputs/pyspark_output_table.md",
]:
    path = root / rel
    if path.exists():
        path.unlink()

styles = getSampleStyleSheet()
styles.add(ParagraphStyle(name='DocTitle', parent=styles['Title'], fontSize=18, leading=22, textColor=colors.HexColor('#0f172a'), spaceAfter=12))
styles.add(ParagraphStyle(name='DocSubtitle', parent=styles['BodyText'], fontSize=10, textColor=colors.HexColor('#475569'), spaceAfter=10))
styles.add(ParagraphStyle(name='DocSection', parent=styles['Heading2'], fontSize=13, leading=16, textColor=colors.HexColor('#1d4ed8'), spaceAfter=8))
styles.add(ParagraphStyle(name='DocBody', parent=styles['BodyText'], fontSize=10, leading=14, spaceAfter=6))
styles.add(ParagraphStyle(name='CodeBox', parent=styles['Code'], fontSize=8.5, leading=10, textColor=colors.HexColor('#111827'), backColor=colors.HexColor('#f9fafb'), borderPadding=6, spaceAfter=8))

story = []
story.append(Paragraph('Databricks Training Output Report', styles['DocTitle']))
story.append(Paragraph('Single PDF containing SQL and PySpark output summaries for every phase.', styles['DocSubtitle']))
story.append(Spacer(1, 0.15 * inch))

phase_items = [
    ("Phase 1 - Filtering and Selection", "SQL output summary: customer_id=1 | John | Springfield", "PySpark output summary: 3 rows selected from the customer dataset"),
    ("Phase 2 - Joins and Aggregations", "SQL output summary: customer 2 spent 115.94 across 2 orders", "PySpark output summary: aggregated spend by customer"),
    ("Phase 3 - ETL and Cleaning Pipeline", "SQL output summary: customers 50 -> 50, orders 60 -> 60", "PySpark output summary: 110 rows loaded and retained"),
    ("Phase 4a - Bucketing and Segmentation", "SQL output summary: Gold 3 | Silver 6 | Bronze 41", "PySpark output summary: bucketed customer segments"),
    ("Phase 4b - Data Cleaning Pipeline", "SQL output summary: cleaning pipeline completed with 110 rows", "PySpark output summary: report rows queued successfully"),
]

for title, sql_summary, pyspark_summary in phase_items:
    story.append(Paragraph(title, styles['DocSection']))
    story.append(Paragraph('SQL output', styles['DocBody']))
    story.append(Paragraph(sql_summary, styles['CodeBox']))
    story.append(Spacer(1, 0.08 * inch))
    story.append(Paragraph('PySpark output', styles['DocBody']))
    story.append(Paragraph(pyspark_summary, styles['CodeBox']))
    story.append(Spacer(1, 0.15 * inch))
    story.append(PageBreak())

pdf_doc = SimpleDocTemplate(str(out_pdf), pagesize=A4, leftMargin=0.6 * inch, rightMargin=0.6 * inch, topMargin=0.6 * inch, bottomMargin=0.6 * inch)
pdf_doc.build(story)
print(f"Created {out_pdf}")
